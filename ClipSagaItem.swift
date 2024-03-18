//
//  ClipSagaItem.swift
//  ClipSaga
//
//  Created by Pratik Ray on 12/03/24.
//

import SwiftUI

struct ClipSagaItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var content: String? // Text content
    var imageData: Data? // Image data
    var timestamp: Date
    var copiedFrom: String?
    

    static func == (lhs: ClipSagaItem, rhs: ClipSagaItem) -> Bool {
        return lhs.id == rhs.id
    }

    init(content: String?, imageData: Data?, timestamp: Date, copiedFrom: String? = nil) {
        self.content = content
        self.imageData = imageData
        self.timestamp = timestamp
        self.copiedFrom = copiedFrom
    }
}
