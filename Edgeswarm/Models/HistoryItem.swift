//
//  HistoryItem.swift
//  Edgeswarm
//
//  Created by Chase Metoyer on 11/26/25.
//

import Foundation

struct HistoryItem: Identifiable, Codable {
    let id: UUID
    let text: String
    let intent: String
    let result: String
    let timestamp: Date
    
    init(text: String, intent: String, result: String) {
        self.id = UUID()
        self.text = text
        self.intent = intent
        self.result = result
        self.timestamp = Date()
    }
}
