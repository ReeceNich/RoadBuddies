//
//  ScoreDial.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 17/04/2023.
//

import SwiftUI

struct ScoreDial: View {
    let percentageDecimal: Double
    let numberOfDialNumbers: Int = 11
    
    var body: some View {
        GeometryReader { geometry in
            let min = min(geometry.size.width, geometry.size.height)
            let width = geometry.size.width
            let height = geometry.size.height
//            let dialRadius = width / 2
            
            ZStack {
                ZStack {
                    Circle()
                        .trim(from: 0.375, to: 0.75)
                        .stroke(Color.red, lineWidth: 30)
                    Circle()
                        .trim(from: 0.75, to: 0.9375)
                        .stroke(Color.yellow, lineWidth: 30)
                    Circle()
                        .trim(from: 0.9375, to: 1)
                        .stroke(Color.green, lineWidth: 30)
                    Circle()
                        .trim(from: 0, to: 0.125)
                        .stroke(Color.green, lineWidth: 30)
                }
                
                Circle()
                    .stroke(Color.primary, lineWidth: 4)
                    .frame(width: width, height: width)
                
                VStack {
                    Spacer(minLength: 0.6 * min)
                    Text("\(String(format: "%.0f", percentageDecimal*100))%")
                        .font(.title2)
                    Spacer()
                }
                .frame(width: width, height: width)
                
                
                withAnimation(.easeInOut) {
                    Path { path in
                        path.move(to: CGPoint(x: width / 2, y: height / 2))
                        path.addLine(to: CGPoint(x: width / 2, y: min))
                    }
                    .stroke(Color.secondary, lineWidth: 6)
                    .rotationEffect(.degrees(180 + (percentageDecimal * 270 - 135)))
                }
                
                
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
        }
    }
}

struct ScoreDial_Previews: PreviewProvider {
    static var previews: some View {
        ScoreDial(percentageDecimal: 0.5)
    }
}
