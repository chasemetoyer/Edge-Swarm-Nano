//
//  NLPService.swift
//  Edgeswarm
//
//  Created by Chase Metoyer on 11/26/25.
//

import Foundation
import NaturalLanguage

class NLPService {
    
    // MARK: - Language Detection
    func detectLanguage(text: String) -> String {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        
        guard let language = recognizer.dominantLanguage else {
            return "Unknown"
        }
        
        return Locale.current.localizedString(forLanguageCode: language.rawValue) ?? language.rawValue
    }
    
    // MARK: - Sentiment Analysis
    func analyzeSentiment(text: String) -> String {
        // 🚀 NEURAL ENGINE: Sentiment Analysis
        // NLTagger uses a bi-directional LSTM (or Transformer on newer iOS) running on the ANE
        // to understand context (e.g., "not bad" = positive).
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        guard let scoreStr = sentiment?.rawValue, let score = Double(scoreStr) else {
            return "😐 Neutral (Score: 0.0)"
        }
        
        // Score is from -1.0 to 1.0
        if score > 0.5 {
            return "🤩 Very Positive (Score: \(String(format: "%.2f", score)))"
        } else if score > 0.1 {
            return "🙂 Positive (Score: \(String(format: "%.2f", score)))"
        } else if score < -0.5 {
            return "🤬 Very Negative (Score: \(String(format: "%.2f", score)))"
        } else if score < -0.1 {
            return "🙁 Negative (Score: \(String(format: "%.2f", score)))"
        } else {
            return "😐 Neutral (Score: \(String(format: "%.2f", score)))"
        }
    }
    
    // MARK: - Entity Extraction
    func extractEntities(text: String) -> String {
        // 🚀 NEURAL ENGINE: Named Entity Recognition (NER)
        // Automatically detects People, Places, and Organizations using on-device ML.
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = text
        
        var people: [String] = []
        var places: [String] = []
        var orgs: [String] = []
        
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
            guard let tag = tag else { return true }
            
            let token = String(text[tokenRange])
            
            switch tag {
            case .personalName:
                if !people.contains(token) { people.append(token) }
            case .placeName:
                if !places.contains(token) { places.append(token) }
            case .organizationName:
                if !orgs.contains(token) { orgs.append(token) }
            default:
                break
            }
            
            return true
        }
        
        var results: [String] = []
        if !people.isEmpty { results.append("👤 People: " + people.joined(separator: ", ")) }
        if !places.isEmpty { results.append("📍 Places: " + places.joined(separator: ", ")) }
        if !orgs.isEmpty { results.append("🏢 Organizations: " + orgs.joined(separator: ", ")) }
        
        if results.isEmpty {
            return "No specific entities found."
        }
        
        return results.joined(separator: "\n")
    }
    
    // MARK: - Summarization (TextRank-ish)
    func summarize(text: String) async -> String {
        // 1. Split into sentences
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        
        var sentences: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
            sentences.append(String(text[tokenRange]))
            return true
        }
        
        if sentences.count <= 3 {
            return text // Too short to summarize
        }
        
        guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else {
            // Fallback: just return first 3 sentences
            return sentences.prefix(3).joined(separator: " ")
        }
        
        // 2. Calculate "importance" by similarity to the whole document
        // A simple heuristic: sentences that are most similar to the *average* of the document
        // are often the most representative.
        
        // Calculate document centroid (average of all sentence vectors) - simplified here by just comparing to the full text
        // Note: Comparing a sentence to the full text is a decent proxy for "centrality"
        
        var rankedSentences: [(index: Int, score: Double, text: String)] = []
        
        for (i, sentence) in sentences.enumerated() {
            // Distance to the full text
            let distance = embedding.distance(between: sentence.lowercased(), and: text.lowercased())
            rankedSentences.append((index: i, score: distance, text: sentence))
        }
        
        // Sort by score (lower distance is better)
        rankedSentences.sort { $0.score < $1.score }
        
        // Take top 3
        let topSentences = rankedSentences.prefix(3)
        
        // Sort back by original index to maintain flow
        let finalSentences = topSentences.sorted { $0.index < $1.index }
        
        return finalSentences.map { $0.text }.joined(separator: " ")
    }
}
