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
        clipboardCheckTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkClipboard), userInfo: nil, repeats: true)
    }
    
    @objc private func checkClipboard() {
        if let newContent = NSPasteboard.general.string(forType: .string) {
            let contentType: ClipSagaItem.ContentType = newContent.hasSuffix(".gif") ? .gif : .text
            addItem(content: newContent, contentType: contentType)
        } else if let imageData = NSPasteboard.general.data(forType: .tiff), let _ = NSImage(data: imageData) {
            // Assume any image data as image content
            addItem(content: "Image", contentType: .image)
        } else if let url = NSPasteboard.general.string(forType: .URL), url.lowercased().hasSuffix(".gif") {
            // Assume a URL ending with ".gif" as GIF content
            addItem(content: url, contentType: .gif)
        }
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
    
    func addItem(content: String, copiedFrom: String? = nil, contentType: ClipSagaItem.ContentType = .text) {
        if let existingItemIndex = clipSagaItems.firstIndex(where: { $0.content == content }) {
            clipSagaItems[existingItemIndex].timestamp = Date()
            clipSagaItems[existingItemIndex].copiedFrom = copiedFrom
        } else {
            let newItem = ClipSagaItem(content: content, timestamp: Date(), copiedFrom: copiedFrom, contentType: contentType)
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
