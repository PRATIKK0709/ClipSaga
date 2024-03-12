//
//  ContentView.swift
//  PastePal
//
//  Created by Pratik Ray on 10/03/24.
//
import SwiftUI

struct ContentView: View {
    @ObservedObject private var pastePalManager = PastePalManager()
    @State private var deletionConfirmation: ClipboardItem?
    @State private var isClearingClipboard: Bool = false
    @State private var showToast: Bool = false

    func filterAndCopyToClipboard(_ content: String) {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "!@#$%^&*()-_=+[{]}|;:'\",.<>?/"))
        let filteredContent = content.filter { character in
            let scalar = character.unicodeScalars.first
            return scalar.map { allowedCharacterSet.contains($0) } ?? false
        }
        
        let containsNonSpace = filteredContent.contains { !$0.isWhitespace }
        
        if !filteredContent.isEmpty && containsNonSpace {
            pastePalManager.copyToClipboard(filteredContent)
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showToast = false
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("PastePal - Clipboard Manager")
                    .font(.title)
                    .padding()

                List {
                    ForEach(pastePalManager.clipboardItems) { item in
                        NavigationLink(destination: PasteDetailView(item: item)) {
                            HStack {
                                Text(item.content)
                                    .font(.body)
                                    .lineLimit(1)
                                    .foregroundColor(.primary)

                                Spacer()

                                // In your Button action:
                                Button(action: {
                                    filterAndCopyToClipboard(item.content)
                                }) {
                                    Image(systemName: "doc.on.clipboard.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 20))
                                }
                                .buttonStyle(BorderlessButtonStyle())

                                Button(action: {
                                    deletionConfirmation = item
                                }) {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 20))
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(VisualEffectBlur())
                .cornerRadius(20)
                .alert(item: $deletionConfirmation) { item in
                    Alert(
                        title: Text("Delete Item"),
                        message: Text("Are you sure you want to delete this item?"),
                        primaryButton: .destructive(Text("Delete")) {
                            pastePalManager.deleteClipboardItem(item)
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                Text("Copied to clipboard!")
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black)
                            .shadow(color: .blue, radius: showToast ? 10 : 0)
                    )
                    .cornerRadius(10)
                    .opacity(showToast ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5))
                    .padding(.bottom, 10)

                Button(action: {
                    isClearingClipboard = true
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Clear Clipboard History")
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .buttonStyle(BorderlessButtonStyle())
                .disabled(pastePalManager.clipboardItems.isEmpty)
                .alert(isPresented: $isClearingClipboard) {
                    Alert(
                        title: Text("Clear Clipboard History"),
                        message: Text("Are you sure you want to clear the clipboard history?"),
                        primaryButton: .destructive(Text("Clear")) {
                            pastePalManager.clearClipboard()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
            .frame(width: 400, height: 500)
        }
    }
}

