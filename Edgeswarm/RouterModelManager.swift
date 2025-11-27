//
//  RouterModelManager.swift
//  Edgeswarm
//
//  Created by Chase Metoyer on 11/1/25.
//
import CoreML

class RouterModelManager {
    private var model: router_model?
    
    let intents = ["summarize", "sentiment", "extract"]
    
    init() {
        do {
            let config = MLModelConfiguration()
            self.model = try router_model(configuration: config)
        } catch {
            print("Error loading model: \(error)")
        }
    }
    
    func predict(text: String) -> (intent: String, confidence: Double) {
        // Simple tokenization (splitting by spaces)
        // This is a basic version - ideally you'd implement BPE tokenization
        let words = text.lowercased().split(separator: " ")
        
        // Create a simple hash-based token ID (simplified version)
        var tokenIds: [Int32] = words.map { word in
            Int32(abs(word.hashValue % 1417)) // 1417 is our vocab size
        }
        
        // Pad or truncate to length 64
        while tokenIds.count < 64 {
            tokenIds.append(0) // 0 is pad token
        }
        if tokenIds.count > 64 {
            tokenIds = Array(tokenIds[..<64])
        }
        
        // Create MLMultiArray for input
        guard let inputArray = try? MLMultiArray(shape: [1, 64], dataType: .int32) else {
            return ("unknown", 0.0)
        }
        
        for i in 0..<64 {
            inputArray[i] = NSNumber(value: tokenIds[i])
        }
        
        // Run prediction
        guard let model = model,
              let prediction = try? model.prediction(input_ids: inputArray) else {
            return ("unknown", 0.0)
        }
        
        // Get logits and find max
        let logits = prediction.logits
        var maxIndex = 0
        var maxValue = logits[0].doubleValue
        
        for i in 1..<3 {
            let value = logits[i].doubleValue
            if value > maxValue {
                maxValue = value
                maxIndex = i
            }
        }
        
        // Calculate softmax for confidence
        var expSum = 0.0
        for i in 0..<3 {
            expSum += exp(logits[i].doubleValue)
        }
        let confidence = exp(maxValue) / expSum
        
        return (intents[maxIndex], confidence)
    }
}
