//
//  PasteDetailView.swift
//  ClipSaga
//
//  Created by Pratik Ray on 12/03/24.
//

import SwiftUI

struct PasteDetailView: View {
    var item: ClipSagaItem
    @Binding var selectedItem: ClipSagaItem?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("ClipSaga - Paste Detail")
                    .font(.title)
                    .padding()

                if let content = item.content {
                    Text(content)
                        .font(.body)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                } else if let imageData = item.imageData {
                    Image(nsImage: NSImage(data: imageData)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }

                // Metadata Section
                Section(header: Text("Metadata").font(.headline)) {
                    if let copiedFrom = item.copiedFrom {
                        Text("Copied from: \(copiedFrom)")
                    }
                    Text("Timestamp: \(formattedTimestamp(item.timestamp))")
                }
            }
            .padding()
            .foregroundColor(.primary)
        }
        .onAppear {
            selectedItem = item
        }
    }


    private func formattedTimestamp(_ timestamp: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        return dateFormatter.string(from: timestamp)
    }
}

