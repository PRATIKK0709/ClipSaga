//
//  ClipboardItem.swift
//  PastePal
//
//  Created by Pratik Ray on 10/03/24.
//

import Foundation
import SwiftUI

struct ClipboardItem: Identifiable, Codable {
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
