//
//  JourneyReportView.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 17/04/2023.
//

import SwiftUI

struct JourneyReportView: View {
    @EnvironmentObject var settings: SettingsStore
    let report: DatabaseManager.JourneyReport
    
    var body: some View {
        VStack {
            Text("Driving Report")
                .font(.title)
            
            HStack {
                // Distance
                VStack {
                    Text("\(String(format: "%.2f", self.report.total_distance))")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    Text("\(settings.distanceUnit.rawValue)")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: 100)
//                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 2)
                )
                
                
                // Speeding
                VStack {
                    Text("\(self.report.speeding_separate_violations)")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    Text("Speeding Violations")
                        .multilineTextAlignment(.center)
                        
                }
                .frame(maxWidth: .infinity, maxHeight: 100)
//                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                )
            }
            .padding(.horizontal, 50)
            
            // Overall score
            VStack {
                Text("Driving Score")
                    .font(.title2)
                
                ScoreDial(percentageDecimal: (100-self.report.speeding_percentage)/100)
                    .frame(width: 100, height: 100)
                    .padding()
            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct JourneyReportView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyReportView(report: DatabaseManager.JourneyReport(journey_id: "1", total_distance: 6.9, speeding_percentage: 75, speeding_separate_violations: 4))
            .environmentObject(SettingsStore())
    }
}
