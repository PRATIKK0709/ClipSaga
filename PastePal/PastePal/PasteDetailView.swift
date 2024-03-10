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
            VStack {
                Text("PastePal - Paste Detail")
                    .font(.title)
                    .padding()

                Text(item.content)
                    .padding()

                HStack {
                    Spacer()
                    VStack {
                        Text("Copied on: \(formattedDate(item.timestamp))")
                        if let copiedFrom = item.copiedFrom {
                            Text("Copied from: \(copiedFrom)")
                        }
                    }
                    Spacer()
                }
                .padding()

                Button(action: {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.writeObjects([item.content as NSString])
                }) {
                    Image(systemName: "doc.on.clipboard.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                        .padding()
                }
                .buttonStyle(BorderlessButtonStyle())

                Spacer()
            }
            .padding()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}
