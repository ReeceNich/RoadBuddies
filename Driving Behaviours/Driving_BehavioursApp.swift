//
//  Driving_BehavioursApp.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 04/10/2022.
//

import SwiftUI

@main
struct Driving_BehavioursApp: App {
    @StateObject var settingsStore = SettingsStore()
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(settingsStore)
        }
    }
}
