//
//  ClipSagaManager.swift
//  ClipSaga
//
//  Created by Pratik Ray on 19/03/24.
//

import SwiftUI
// ClipSagaManager
extension ClipSagaManager {
    func copyImageToClipboard(_ imageData: Data) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setData(imageData, forType: .tiff)
    }
}
