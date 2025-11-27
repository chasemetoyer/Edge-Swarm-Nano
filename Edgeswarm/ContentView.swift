//
//  ContentView.swift
//  Edgeswarm
//
//  Created by Chase Metoyer on 11/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showHistory = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 5) {
                        Text("Edge-Swarm-Nano")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("AI Router + Task Processor")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top)
                    
                    // Input Area
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Input Text:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            if !viewModel.detectedLanguage.isEmpty && viewModel.detectedLanguage != "Unknown" {
                                Text(viewModel.detectedLanguage)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.1))
                                    .foregroundColor(.green)
                                    .cornerRadius(4)
                            }
                        }
                        
                        ZStack(alignment: .bottomTrailing) {
                            TextEditor(text: $viewModel.inputText)
                                .frame(height: 120)
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            
                            // Mic Button
                            Button(action: viewModel.toggleRecording) {
                                Image(systemName: viewModel.speechService.isRecording ? "mic.fill" : "mic")
                                    .font(.system(size: 20))
                                    .foregroundColor(viewModel.speechService.isRecording ? .red : .blue)
                                    .padding(10)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                            }
                            .padding(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Process Button
                    Button(action: viewModel.processText) {
                        HStack {
                            if viewModel.isProcessing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(viewModel.isProcessing ? "Processing..." : "Process with AI")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isProcessing ? Color.gray : Color.blue)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .disabled(viewModel.isProcessing || viewModel.inputText.isEmpty)
                    
                    // Results Area
                    if let intent = viewModel.predictedIntent {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🧭 Router Analysis:")
                                .font(.headline)
                            
                            HStack {
                                Text("Detected Intent:")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(intent.description)
                                    .foregroundColor(.blue)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            
                            HStack {
                                Text("Confidence:")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(String(format: "%.1f%%", viewModel.confidence * 100))
                                    .foregroundColor(viewModel.confidence > 0.8 ? .green : .orange)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    
                    if !viewModel.taskResult.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(getResultIcon() + " " + getResultTitle())
                                .font(.headline)
                            
                            Text(viewModel.taskResult)
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                        .padding()
                        .background(getResultColor().opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    
                    // Examples
                    VStack(spacing: 8) {
                        Text("Try these examples:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        ExampleButton(text: "Climate change...", label: "Summarize Example") {
                            viewModel.setExample("Climate change is one of the most pressing issues facing humanity. Rising temperatures are causing ice caps to melt and sea levels to rise. Scientists warn that immediate action is needed to reduce greenhouse gas emissions.")
                        }
                        
                        ExampleButton(text: "Amazing product...", label: "Sentiment Example") {
                            viewModel.setExample("This product is absolutely amazing! Best purchase I've ever made. Highly recommend to everyone!")
                        }
                        
                        ExampleButton(text: "John Smith...", label: "Extract Example") {
                            viewModel.setExample("John Smith, age 45, lives in New York. He works as a software engineer at TechCorp since 2015.")
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.bottom)
            }
            .navigationBarHidden(true)
            .overlay(
                // History Button
                Button(action: { showHistory = true }) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding()
                , alignment: .topTrailing
            )
            .sheet(isPresented: $showHistory) {
                HistoryView(history: viewModel.history)
            }
        }
    }
    
    // Helpers
    func getResultIcon() -> String {
        switch viewModel.predictedIntent {
        case .summarize: return "📝"
        case .sentiment: return "💭"
        case .extract: return "🔍"
        default: return "❓"
        }
    }
    
    func getResultTitle() -> String {
        switch viewModel.predictedIntent {
        case .summarize: return "Summarization Result"
        case .sentiment: return "Sentiment Analysis"
        case .extract: return "Extracted Information"
        default: return "Result"
        }
    }
    
    func getResultColor() -> Color {
        switch viewModel.predictedIntent {
        case .summarize: return .blue
        case .sentiment: return .purple
        case .extract: return .orange
        default: return .gray
        }
    }
}

struct HistoryView: View {
    let history: [HistoryItem]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(history) { item in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(item.intent)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                        Spacer()
                        Text(item.timestamp, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text(item.text)
                        .font(.subheadline)
                        .lineLimit(2)
                    
                    Divider()
                    
                    Text(item.result)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("History")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ExampleButton: View {
    let text: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.footnote)
                .foregroundColor(.blue)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                .frame(maxWidth: .infinity)
        }
    }
}
