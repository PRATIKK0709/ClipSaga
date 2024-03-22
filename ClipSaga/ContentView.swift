//
//  ContentView.swift
//  ClipSaga
//
//  Created by Pratik Ray on 12/03/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var clipSagaManager = ClipSagaManager()
    @State private var deletionConfirmation: ClipSagaItem?
    @State private var isClearingClipSaga: Bool = false
    @State private var showToast: Bool = false
    @State private var showSettings: Bool = false // New state for showing settings
    @State private var selectedItem: ClipSagaItem?

    var body: some View {
        NavigationView {
            VStack {
                Text("ClipSaga - Clipboard Manager")
                    .font(.title)
                    .padding()

                List {
                    ForEach(clipSagaManager.clipSagaItems.indices, id: \.self) { index in
                        let item = clipSagaManager.clipSagaItems[index]
                        Button(action: {
                            selectedItem = item // Set the selected item
                        }) {
                            HStack {
                                if let content = item.content {
                                    Text(content)
                                        .font(.body)
                                        .lineLimit(1)
                                        .foregroundColor(.primary)
                                        .padding(.vertical, 8)
                                } else if let _ = item.imageData {
                                    Text("Image \(clipSagaManager.clipSagaItems.count - index)")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .padding(.vertical, 8)
                                }
                                Spacer()
                                Button(action: {
                                    // Perform copy action
                                    if let content = item.content {
                                        clipSagaManager.copyToClipboard(content)
                                        showToast = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            showToast = false
                                        }
                                    } else if let imageData = item.imageData {
                                        clipSagaManager.copyImageToClipboard(imageData)
                                        showToast = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            showToast = false
                                        }
                                    }
                                }) {
                                    Image(systemName: "doc.on.doc")
                                        .foregroundColor(.blue)
                                        .font(.title)
                                }
                                .buttonStyle(BorderlessButtonStyle())

                                Button(action: {
                                    deletionConfirmation = item // Set item for deletion confirmation
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .font(.title)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove button style
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
                            clipSagaManager.deleteClipSagaItem(item)
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

                Spacer() // Add Spacer to push the button to the bottom

                Button(action: {
                    isClearingClipSaga = true
                }) {
                    Text("Clear Clipboard History")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.clear) // Set button background color to clear
                .buttonStyle(BorderlessButtonStyle())
                .disabled(clipSagaManager.clipSagaItems.isEmpty)
                .alert(isPresented: $isClearingClipSaga) {
                    Alert(
                        title: Text("Clear Clipboard History"),
                        message: Text("Are you sure you want to clear the clipboard history?"),
                        primaryButton: .destructive(Text("Clear")) {
                            clipSagaManager.clearClipSaga()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding()
            .frame(width: 400, height: 500)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                    }
                }
            }

            Group {
                if showSettings {
                    // Show settings view
                    SettingsView(showingSettings: $showSettings)
                } else {
                    // Show PasteDetailView
                    PasteDetailView(item: selectedItem ?? ClipSagaItem(content: nil, imageData: nil, timestamp: Date()), selectedItem: $selectedItem)
                }
            }
        }
        .navigationTitle("ClipSaga")
    }
}
