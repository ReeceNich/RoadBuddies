//
//  JourneyDetailView.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 29/03/2023.
//

import SwiftUI
import MapKit

struct JourneyDetailView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var settings: SettingsStore
    @State private var report: DatabaseManager.JourneyReport?
    var journey: DatabaseManager.Journey
    
    var body: some View {
        ScrollView {
//            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: journey.events?[0].latitude ?? 0, longitude: journey.events?[0].longitude ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))))
//                .allowsHitTesting(false)
//                .frame(height: 300)
            
            if (self.report != nil) {
                JourneyMapView(journey: journey, report: report)
                    .allowsHitTesting(true)
                    .frame(height: 300)
            } else {
                JourneyMapView(journey: journey, report: report)
                    .allowsHitTesting(true)
                    .frame(height: 300)
            }
            
            Text("\(journey.time_started)")
                .font(.headline)
            
            Divider()
            
            VStack {
                Text("Driving Report")
                    .font(.title)
                // TODO: Insert driving report here.
                if (self.report != nil) {
                    Text("Distance: \(self.report!.total_distance) \(settings.distanceUnit.rawValue)")
                    Text("Speeding Violations: \(self.report!.speeding_separate_violations) violations")
                    Text("Speeding Percentage: \(self.report!.speeding_percentage)%")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
//            .background(Color.secondary)
            
        }
        .navigationTitle("Journey Driving Report")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            print("report")
            databaseManager.getJourneyReport(journey_id: self.journey.journey_id) { (journeyReport) in
                var report = journeyReport
                report.total_distance = settings.convertDistance(to: settings.distanceUnit, value: journeyReport.total_distance)
                
                self.report = report
            }
        }
    
    }
}

struct JourneyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyDetailView(journey: DatabaseManager.Journey(journey_id: "1", user_id: "1", time_started: Date.now, time_ended: Date.now+5000, events: [DatabaseManager.JourneyEvent(journey_id: "1", event_id: "1", latitude: 51.5005, longitude: -0.1198, time: Date.now+1, speed: 10, is_speeding: false)]))
    }
}
