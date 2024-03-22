//
//  ClipSageManager.swift
//  ClipSaga
//
//  Created by Pratik Ray on 12/03/24.
//

import SwiftUI

class ClipSagaManager: ObservableObject {
    @Published var clipSagaItems: [ClipSagaItem] = []

    private var clipboardCheckTimer: Timer?

    init() {
        startClipboardMonitoring()
        loadClipSagaItems()
    }

    private func startClipboardMonitoring() {
        clipboardCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkClipboard()
        }
    }

    private func checkClipboard() {
        if let newContent = NSPasteboard.general.string(forType: .string) {
            let copiedFrom = detectCopiedFromApplication()
            addItem(content: newContent, imageData: nil, copiedFrom: copiedFrom)
        } else if let newImageData = NSPasteboard.general.data(forType: .tiff) {
            let copiedFrom = detectCopiedFromApplication()
            addItem(content: nil, imageData: newImageData, copiedFrom: copiedFrom)
        }
    }

    private func detectCopiedFromApplication() -> String? {
        guard let types = NSPasteboard.general.types else {
            return nil
        }

        if types.contains(.URL) {
            return "URL"
        } else if types.contains(.fileURL) {
            return "File URL"
        } else if types.contains(.html) {
            return "HTML"
        } else if types.contains(.tiff) {
            return "Image"
        }
        // Add more cases if needed
        return nil
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func loadClipSagaItems() {
        if let data = UserDefaults.standard.data(forKey: "clipSagaItems"),
           let loadedItems = try? JSONDecoder().decode([ClipSagaItem].self, from: data) {
            clipSagaItems = loadedItems
        }
    }

    private func saveClipSagaItems() {
        if let encodedData = try? JSONEncoder().encode(clipSagaItems) {
            UserDefaults.standard.set(encodedData, forKey: "clipSagaItems")
        }

    }

    func addItem(content: String?, imageData: Data?, copiedFrom: String? = nil) {
        if let existingItemIndex = clipSagaItems.firstIndex(where: { $0.content == content && $0.imageData == imageData }) {
            clipSagaItems[existingItemIndex].timestamp = Date()
            clipSagaItems[existingItemIndex].copiedFrom = copiedFrom
        } else {
            let newItem = ClipSagaItem(content: content, imageData: imageData, timestamp: Date(), copiedFrom: copiedFrom)
            clipSagaItems.insert(newItem, at: 0)
        }
    }

    func copyToClipboard(_ content: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.writeObjects([content as NSString])
    }

    func deleteClipSagaItem(_ item: ClipSagaItem) {
        guard let index = clipSagaItems.firstIndex(where: { $0.id == item.id }) else { return }
        clipSagaItems.remove(at: index)
        saveClipSagaItems()

        // Clear the clipboard content after saving the changes
        NSPasteboard.general.clearContents()
    }

    func clearClipSaga() {
        clipSagaItems.removeAll()
        saveClipSagaItems()

        // Clear the clipboard content after saving the changes
        NSPasteboard.general.clearContents()
    }
}
