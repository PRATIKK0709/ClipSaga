//
//  PasteDetailView.swift
//  ClipSaga
//
//  Created by Pratik Ray on 12/03/24.
//

import SwiftUI

struct PasteDetailView: View {
    var item: ClipSagaItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("ClipSaga - Paste Detail")
                    .font(.title)
                    .padding()

                if item.contentType == .text {
                    Text(item.content)
                        .font(.body)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                } else if item.contentType == .image || item.contentType == .gif {
                    // Placeholder for image or GIF display
                    // You can customize this part based on your needs
                    Text("Image or GIF Placeholder")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                }

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
