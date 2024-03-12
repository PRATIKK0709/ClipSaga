//
//  PastePalManager.swift
//  PastePal
//
//  Created by Pratik Ray on 10/03/24.
//

import Foundation
import SwiftUI

class PastePalManager: ObservableObject {
    @Published var clipboardItems: [ClipboardItem] = []
    
    private var clipboardCheckTimer: Timer?
    
    init() {
        startClipboardMonitoring()
        loadClipboardItems()
    }
    
    private func startClipboardMonitoring() {
        clipboardCheckTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkClipboard), userInfo: nil, repeats: true)
    }
    
    @objc private func checkClipboard() {
        if let newContent = NSPasteboard.general.string(forType: .string) {
            let contentType: ClipboardItem.ContentType = newContent.hasSuffix(".gif") ? .gif : .text
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
    
    @objc private func handleClipboardChange() {
        if let newContent = NSPasteboard.general.string(forType: .string) {
            let contentType: ClipboardItem.ContentType = newContent.hasSuffix(".gif") ? .gif : .text
            addItem(content: newContent, contentType: contentType)
        } else if let imageData = NSPasteboard.general.data(forType: .tiff), let _ = NSImage(data: imageData) {
            // Assume any image data as image content
            addItem(content: "Image", contentType: .image)
        } else if let url = NSPasteboard.general.string(forType: .URL), url.lowercased().hasSuffix(".gif") {
            // Assume a URL ending with ".gif" as GIF content
            addItem(content: url, contentType: .gif)
        }
    }
    
    private func loadClipboardItems() {
        if let data = UserDefaults.standard.data(forKey: "clipboardItems"),
           let loadedItems = try? JSONDecoder().decode([ClipboardItem].self, from: data) {
            clipboardItems = loadedItems
        }
    }
    
    private func saveClipboardItems() {
        if let encodedData = try? JSONEncoder().encode(clipboardItems) {
            UserDefaults.standard.set(encodedData, forKey: "clipboardItems")
        }
        
    }
    
    func addItem(content: String, copiedFrom: String? = nil, contentType: ClipboardItem.ContentType = .text) {
        if let existingItemIndex = clipboardItems.firstIndex(where: { $0.content == content }) {
            clipboardItems[existingItemIndex].timestamp = Date()
            clipboardItems[existingItemIndex].copiedFrom = copiedFrom
        } else {
            let newItem = ClipboardItem(content: content, timestamp: Date(), copiedFrom: copiedFrom, contentType: contentType)
            clipboardItems.insert(newItem, at: 0)
        }
    }
    
    func copyToClipboard(_ content: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.writeObjects([content as NSString])
    }
    
    func deleteClipboardItem(_ item: ClipboardItem) {
        guard let index = clipboardItems.firstIndex(where: { $0.id == item.id }) else { return }
        clipboardItems.remove(at: index)
        saveClipboardItems()
        
        // Clear the clipboard content after saving the changes
        NSPasteboard.general.clearContents()
    }

    
    
    func clearClipboard() {
        clipboardItems.removeAll()
        saveClipboardItems()
        
        // Clear the clipboard content after saving the changes
        NSPasteboard.general.clearContents()
    }
}
