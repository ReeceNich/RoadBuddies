//
//  SettingsView.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 05/10/2022.
//

import SwiftUI

struct SpeedUnit: Identifiable {
    let id: Int
    let name: String
    let multiplierFromMs: Double
}

struct SettingsView: View {
    var speedUnits = [
        SpeedUnit(id: 0, name: "ms", multiplierFromMs: 1),
        SpeedUnit(id: 1, name: "mph", multiplierFromMs: 2.237),
        SpeedUnit(id: 2, name: "kph", multiplierFromMs: 3.6)
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section("Speed Units") {
                    ForEach(speedUnits) { speedUnit in
                        HStack {
                            Text("\(speedUnit.name)")
                            Spacer()
                        }
                    }
                }
                
                Section("Speed Units") {
                    ForEach(speedUnits) { speedUnit in
                        HStack {
                            Text("\(speedUnit.name)")
                            Spacer()
                        }
                    }
                }
                
                
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
