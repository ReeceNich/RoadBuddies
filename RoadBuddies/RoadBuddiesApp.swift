//
//  Driving_BehavioursApp.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 04/10/2022.
//

import SwiftUI

@main
struct RoadBuddiesApp: App {
    @StateObject var settingsStore = SettingsStore()
    @StateObject var databaseManager = DatabaseManager()
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(settingsStore)
                .environmentObject(databaseManager)
        }
    }
}
