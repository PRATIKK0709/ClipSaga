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

    init(content: String, timestamp: Date, copiedFrom: String? = nil) {
        self.content = content
        self.timestamp = timestamp
        self.copiedFrom = copiedFrom
    }
}
