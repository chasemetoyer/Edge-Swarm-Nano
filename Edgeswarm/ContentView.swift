//
//  ContentView.swift
//  Edgeswarm
//
//  Created by Chase Metoyer on 11/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Edge-Swarm-Nano")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("AI Router + Task Processor")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                // Input text field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Input Text:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    TextEditor(text: $viewModel.inputText)
                        .frame(height: 100)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                
                // Process button
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
                
                // Router Results
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // Task Result
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(getResultColor().opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // Example inputs
                VStack(spacing: 8) {
                    Text("Try these examples:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    ExampleButton(
                        text: "Climate change is one of the most pressing issues. Rising temperatures are causing ice caps to melt.",
                        label: "Summarize Example",
                        action: {
                            viewModel.setExample("Climate change is one of the most pressing issues facing humanity. Rising temperatures are causing ice caps to melt and sea levels to rise. Scientists warn that immediate action is needed to reduce greenhouse gas emissions.")
                        }
                    )
                    
                    ExampleButton(
                        text: "This product is amazing! Best purchase ever!",
                        label: "Sentiment Example",
                        action: {
                            viewModel.setExample("This product is absolutely amazing! Best purchase I've ever made. Highly recommend to everyone!")
                        }
                    )
                    
                    ExampleButton(
                        text: "John Smith, age 45, lives in New York...",
                        label: "Extract Example",
                        action: {
                            viewModel.setExample("John Smith, age 45, lives in New York. He works as a software engineer at TechCorp since 2015.")
                        }
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
    
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

#Preview {
    ContentView()
}
