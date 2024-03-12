//
//  ClipSagaItem.swift
//  ClipSaga
//
//  Created by Pratik Ray on 12/03/24.
//

import SwiftUI

struct ClipSagaItem: Identifiable, Codable {
    var id = UUID()
    let content: String
    var timestamp: Date
    var copiedFrom: String?
    var contentType: ContentType

    enum ContentType: String, Codable {
        case text
        case image
        case gif
    }

    init(content: String, timestamp: Date, copiedFrom: String? = nil, contentType: ContentType = .text) {
        self.content = content
        self.timestamp = timestamp
        self.copiedFrom = copiedFrom
        self.contentType = contentType
    }
}
