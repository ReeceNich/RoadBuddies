//
//  SpeedLimitSign.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 05/10/2022.
//

import SwiftUI

struct SpeedLimitSign: View {
    @EnvironmentObject var settings: SettingsStore
    
    var limit: Int = 88
    var currentSpeedInMs: Double = 99
    
    var body: some View {
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
            
            Text("\n\n\n" + settings.speedUnit.rawValue)
                .font(.caption2)
                
            
        }
        
    }
}

struct SpeedLimitSign_Previews: PreviewProvider {
    static var previews: some View {
        SpeedLimitSign()
            .environmentObject(SettingsStore())
    }
}
