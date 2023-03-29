//
//  JourneyDetailView.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 29/03/2023.
//

import SwiftUI
import MapKit

struct JourneyDetailView: View {
    var journey: DatabaseManager.Journey
    
    var body: some View {
        ScrollView {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: journey.events?[0].latitude ?? 0, longitude: journey.events?[0].longitude ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))))
                .allowsHitTesting(false)
                .frame(height: 300)
            
            Text("\(journey.time_started)")
                .font(.headline)
            
            Divider()
            
            VStack {
                Text("Driving Report")
                    .font(.title)
                // TODO: Insert driving report here.
            }
            .frame(maxWidth: .infinity)
            .padding()
//            .background(Color.secondary)
        }
        .navigationTitle("Journey Driving Report")
        .navigationBarTitleDisplayMode(.inline)
    
    }
}

struct JourneyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyDetailView(journey: DatabaseManager.Journey(journey_id: "1", user_id: "1", time_started: Date.now, time_ended: Date.now+5000, events: [DatabaseManager.JourneyEvent(journey_id: "1", event_id: "1", latitude: 51.5005, longitude: -0.1198, time: Date.now+1, speed: 10, is_speeding: false)]))
    }
}
