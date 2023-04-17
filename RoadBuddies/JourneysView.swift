//
//  JourneysView.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 29/03/2023.
//

import SwiftUI
import MapKit

struct JourneysView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
//    @State private var cachedJourneys: [DatabaseManager.Journey]?
    
    var body: some View {
        NavigationView {
            List {
                if (databaseManager.cachedJourneys != []) {
                    Section("Local Journeys (to be uploaded)") {
                        Text("There are journeys to upload")
                        Button {
                            DispatchQueue.global(qos: .background).async {
                                databaseManager.uploadCachedJourneys()
                                // Get all journeys
                            }
                        } label: {
                            Text("Upload!")
                        }
                        
                        Button {
                            databaseManager.resetCachedJourneys()
                        } label: {
                            Text("Reset cached...")
                        }

                    }
                    
                    ForEach(databaseManager.cachedJourneys ?? []) { row in
                        Text(row.journey_id)
                    }
                }
                
                
                Section() {
                    ForEach(databaseManager.allJourneys ?? []) { row in
                        NavigationLink(destination: JourneyDetailView(journey: row)) {
//                            Text("Journey ID \(row.journey_id)")
                            VStack {
                                Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: row.events?[0].latitude ?? 0, longitude: row.events?[0].longitude ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))))
                                    .allowsHitTesting(false)
                                    .frame(height: 100)
                                
                                Text("\(row.time_started)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Journeys")
            
        }
        .onAppear() {
            DispatchQueue.global(qos: .background).async {
                // Get all journeys
                databaseManager.getAllJourneys() { (data) in
                    print("Got all journeys")
                }
            }
            
            _ = databaseManager.loadCachedJourneys()
        }
    }
}

struct JourneysView_Previews: PreviewProvider {
    static var previews: some View {
        let db = DatabaseManager()
        db.allJourneys = [DatabaseManager.Journey(journey_id: "1", user_id: "1", time_started: Date.now, time_ended: Date.now+5000, events: [DatabaseManager.JourneyEvent(journey_id: "1", event_id: "1", latitude: 51.5005, longitude: -0.1198, time: Date.now+1, speed: 10, is_speeding: false)]),
                          DatabaseManager.Journey(journey_id: "1", user_id: "1", time_started: Date.now, time_ended: Date.now+5000, events: [DatabaseManager.JourneyEvent(journey_id: "1", event_id: "1", latitude: 51.5005, longitude: -0.1198, time: Date.now+1, speed: 10, is_speeding: false)])]
        
        return JourneysView()
            .environmentObject(db)
    }
}
