//
//  SettingsView.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 05/10/2022.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var settings: SettingsStore
    
    var body: some View {
        NavigationView {
            List {
                Section("Speed Units") {
                    Picker("Select your speed units", selection: $settings.speedUnit) {
                        ForEach(SettingsStore.SpeedUnit.allCases) { speedUnit in
                            HStack {
                                Text("\(speedUnit.rawValue)")
                                Spacer()
                            }
                            .tag(speedUnit)
                        }
                    }
                }
                
//                Section("Speed Units") {
//                    ForEach(speedUnits) { speedUnit in
//                        HStack {
//                            Text("\(speedUnit.name)")
//                            Spacer()
//                        }
//                    }
//                }
                
                
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsStore())
    }
}
