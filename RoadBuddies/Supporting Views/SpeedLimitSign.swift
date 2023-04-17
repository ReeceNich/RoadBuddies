//
//  SpeedLimitSign.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 05/10/2022.
//

import SwiftUI

struct SpeedLimitSign: View {
    @EnvironmentObject var settings: SettingsStore
    
    var limit: Int = 88
    var unit: SettingsStore.SpeedUnit = .kmh
    
    var body: some View {
        if limit >= 0 {
            ZStack {
                Text("top")
                
                Text("\(limit)")
                    .padding(25)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .background(
                        Circle()
                            .strokeBorder(.red, lineWidth: 8)
                            .background(Circle().fill(.white))
                    )
                
                Text("\n\n\n" + unit.rawValue)
                    .font(.caption2)
                    .foregroundColor(.black)
                
                
            }
        }
        
    }
}

struct SpeedLimitSign_Previews: PreviewProvider {
    static var previews: some View {
        SpeedLimitSign()
            .environmentObject(SettingsStore())
    }
}
