//
//  PasteDetailView.swift
//  PastePal
//
//  Created by Pratik Ray on 10/03/24.
//

import Foundation
import SwiftUI

struct PasteDetailView: View {
    var item: ClipboardItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("PastePal - Paste Detail")
                    .font(.title)
                    .padding()

                Text(item.content)
                    .font(.body)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)

                // Metadata Section
                Section(header: Text("Metadata").font(.headline)) {
                    if let copiedFrom = item.copiedFrom {
                        Text("Copied from: \(copiedFrom)")
                    }
                    Text("Timestamp: \(formattedTimestamp(item.timestamp))")
                    Text("Number of Words: \(wordCount(item.content))")
                }
            }
            .padding()
            .foregroundColor(.primary)
        }
    }

    private func formattedTimestamp(_ timestamp: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        return dateFormatter.string(from: timestamp)
    }

    private func wordCount(_ text: String) -> Int {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        return words.filter { !$0.isEmpty }.count
    }
}
