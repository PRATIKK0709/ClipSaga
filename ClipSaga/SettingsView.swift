//
//  SettingsView.swift
//  ClipSaga
//
//  Created by Pratik Ray on 19/03/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showingSettings: Bool

    var body: some View {
        Text("Settings")
            .padding()
            .onDisappear {
                // Reset showingSettings when the SettingsView is dismissed
                showingSettings = false
            }
    }
}
