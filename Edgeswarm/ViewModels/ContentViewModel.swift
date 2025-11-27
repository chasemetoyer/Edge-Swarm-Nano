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
    
    // MARK: - Services
    private let routerService = RouterService()
    private let nlpService = NLPService()
    
    // MARK: - Actions
    func processText() {
        guard !inputText.isEmpty else { return }
        
        isProcessing = true
        taskResult = ""
        predictedIntent = nil
        
        Task {
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
        }
    }
    
    // MARK: - Helper for UI
    func setExample(_ text: String) {
        self.inputText = text
    }
}
