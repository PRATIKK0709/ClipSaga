//
//  VisualEffectsBlur.swift
//  ClipSaga
//
//  Created by Pratik Ray on 12/03/24.
//

import SwiftUI

struct VisualEffectBlur: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.material = .sidebar
        return visualEffectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        // No update needed
    }
}
