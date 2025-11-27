//
//  RouterService.swift
//  Edgeswarm
//
//  Created by Chase Metoyer on 11/26/25.
//

import Foundation
import NaturalLanguage

enum RouterIntent: String, CaseIterable {
    case summarize
    case sentiment
    case extract
    case unknown
    
    var description: String {
        switch self {
        case .summarize: return "Summarize"
        case .sentiment: return "Sentiment Analysis"
        case .extract: return "Extract Information"
        case .unknown: return "Unknown"
        }
    }
}

class RouterService {
    // Target concepts to compare against
    // We use a mix of "commands" and "representative content" to catch both styles of input
    private let intentDescriptions: [RouterIntent: String] = [
        .summarize: "summarize this text, tl;dr, brief overview. Climate change is causing global warming. The economy is growing. A long story about history.",
        .sentiment: "review, opinion, feedback, rating. I love this product, it is amazing, terrible experience, worst purchase, 5 stars, best ever.",
        .extract: "extract names, find numbers, get data. Call me at 555-1234. My email is test@example.com. John Smith lives in New York."
    ]
    
    func predictIntent(for text: String) async -> (intent: RouterIntent, confidence: Double) {
        // 🚀 CORE FEATURE: Zero-Shot Classification via Neural Engine
        // This call offloads vector embedding calculations to the device's ANE (Apple Neural Engine).
        // It converts text into a 512-dimensional vector to understand semantic meaning.
        guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else {
            print("Error: NLEmbedding not available")
            return (.unknown, 0.0)
        }
        
        // If text is very short, it might be hard to classify by embedding alone, 
        // but we'll try anyway.
        
        var maxDistance = Double.infinity // Lower distance is better (0.0 is identical)
        var bestIntent = RouterIntent.unknown
        
        for (intent, description) in intentDescriptions {
            // We compare the distance between the user input and our "intent description"
            let distance = embedding.distance(between: text.lowercased(), and: description)
            
            // NLEmbedding distance is between 0.0 (same) and 2.0 (opposite)
            if distance < maxDistance {
                maxDistance = distance
                bestIntent = intent
            }
        }
        
        // Convert distance to a "confidence" score (0 to 1)
        // Distance 0 -> Confidence 1
        // Distance 2 -> Confidence 0
        let confidence = 1.0 - (maxDistance / 2.0)
        
        // Threshold: Lowered to 0.35 to be more permissive with semantic matching
        if confidence < 0.35 {
            return (.unknown, confidence)
        }
        
        return (bestIntent, confidence)
    }
}
