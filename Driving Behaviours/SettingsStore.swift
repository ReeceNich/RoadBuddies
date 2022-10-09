//
//  SettingsStore.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 06/10/2022.
//

import Foundation


class SettingsStore: ObservableObject {
    init() {
        // Retrieve from UserDefaults
        if let data = UserDefaults.standard.object(forKey: "speedUnit") as? Data,
           let unit = try? JSONDecoder().decode(SpeedUnit.self, from: data) {
            print("Retrieved Speed Unit: " + unit.rawValue)
            self.speedUnit = unit
        }
    }
    
    @Published var speedUnit: SpeedUnit = .ms {
        willSet {
            print("Setting Speed Unit")

            // To store in UserDefaults
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "speedUnit")
            }
        }
    }
    
    
    
    enum SpeedUnit: String, CaseIterable, Identifiable, Codable {
        case ms = "m/s"
        case mph = "mph"
        case kmh = "km/h"
        var id: String { return self.rawValue }
    }
    
    
    func convertSpeed(from: SpeedUnit = .ms, to: SpeedUnit, value: Double) -> Double {
        var toConvert = value
        
        if from != .ms {
            if from == .kmh {
                toConvert = value / 3.6
            }
            
            if from == .mph {
                toConvert = value / 2.23694
            }
        }
    
        
        switch to {
            case .ms:
                return 1.0 * toConvert
            case .mph:
                return 2.23694 * toConvert
            case .kmh:
                return 3.6 * toConvert
//            default:
//                return 1.0
        }
    }
    
    
}
