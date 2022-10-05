//
//  SpeedLimitSign.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 05/10/2022.
//

import SwiftUI

struct SpeedLimitSign: View {
    var limit: Int = 95
    var currentSpeed: Int = 99
    
    var body: some View {
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
    }
}

struct SpeedLimitSign_Previews: PreviewProvider {
    static var previews: some View {
        SpeedLimitSign()
    }
}
