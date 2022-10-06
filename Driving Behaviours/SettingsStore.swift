//
//  SettingsStore.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 06/10/2022.
//

import Foundation


class SettingsStore: ObservableObject {
    
    enum SpeedUnit: String {
        case ms = "m/s"
        case mph = "mph"
        case kph = "kph"
    }
    
    
    
    func speedMsMultiplier(convertTo: SpeedUnit) -> Double {
        switch convertTo {
            case .ms:
                return 1.0
            case .mph:
                return 2.23694
            case .kph:
                return 3.6
//            default:
//                return 1.0
        }
    }
    
    
}
