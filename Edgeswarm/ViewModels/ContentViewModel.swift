//
//  ContentViewModel.swift
//  Edgeswarm
//
//  Created by Chase Metoyer on 11/26/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ContentViewModel: ObservableObject {
    // MARK: - State
    @Published var inputText: String = ""
    @Published var predictedIntent: RouterIntent? = nil
    @Published var confidence: Double = 0.0
    @Published var taskResult: String = ""
    @Published var isProcessing: Bool = false
    @Published var detectedLanguage: String = ""
    @Published var history: [HistoryItem] = [] {
        didSet {
            saveHistory()
        }
    }
    
    // MARK: - Services
    private let routerService = RouterService()
    private let nlpService = NLPService()
    @Published var speechService = SpeechService()
    
    private let historyKey = "edgeswarm_history"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadHistory()
        
        // Sync speech text to input text
        speechService.$transcribedText
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .assign(to: \.inputText, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    func processText() {
        guard !inputText.isEmpty else { return }
        
        isProcessing = true
        taskResult = ""
        predictedIntent = nil
        detectedLanguage = ""
        
        Task {
            // 0. Language Detection
            let lang = nlpService.detectLanguage(text: inputText)
            self.detectedLanguage = lang
            
            // 1. Router Step
            let (intent, conf) = await routerService.predictIntent(for: inputText)
            
            self.predictedIntent = intent
            self.confidence = conf
            
            // 2. Execution Step
            // Add a small delay for better UX (so user sees the router decision)
            try? await Task.sleep(nanoseconds: 800_000_000) // 0.8 seconds
            
            let result: String
            switch intent {
            case .summarize:
                result = await nlpService.summarize(text: inputText)
            case .sentiment:
                result = nlpService.analyzeSentiment(text: inputText)
            case .extract:
                result = nlpService.extractEntities(text: inputText)
            case .unknown:
                result = "Could not determine the best task for this text. Try being more specific."
            }
            
            self.taskResult = result
            self.isProcessing = false
            
            // 3. Save to History
            if intent != .unknown {
                let item = HistoryItem(text: inputText, intent: intent.description, result: result)
                DispatchQueue.main.async {
                    self.history.insert(item, at: 0)
                }
            }
        }
    }
    
    func toggleRecording() {
        if speechService.isRecording {
            speechService.stopRecording()
        } else {
            speechService.requestAuthorization()
            do {
                try speechService.startRecording()
            } catch {
                print("Error starting recording: \(error)")
            }
        }
    }
    
    // MARK: - History Persistence
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([HistoryItem].self, from: data) {
            self.history = decoded
        }
    }
    
    // MARK: - Helper for UI
    func setExample(_ text: String) {
        self.inputText = text
    }
}
