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

    var body: some View {
        NavigationView {
            VStack {
                Text("ClipSaga - Clipboard Manager")
                    .font(.title)
                    .padding()

                List {
                    ForEach(clipSagaManager.clipSagaItems) { item in
                        NavigationLink(destination: PasteDetailView(item: item)) {
                            HStack {
                                Text(item.content)
                                    .font(.body)
                                    .lineLimit(1)
                                    .foregroundColor(.primary)

                                Spacer()

                                Button(action: {
                                    clipSagaManager.copyToClipboard(item.content)
                                    showToast = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        showToast = false
                                    }
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

                Button(action: {
                    isClearingClipSaga = true
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
        }
    }
}
