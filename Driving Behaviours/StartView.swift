//
//  StartView.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 04/10/2022.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @EnvironmentObject var databaseManager: DatabaseManager
    
    var body: some View {
        // Show the user auth screen if not authorised
        NavigationView {
            Group {
                if locationManager.userLocation == nil {
                    LocationRequestView()
                    

//                } else if let userLocation = locationManager.userLocation {
                } else {
                    
                    TabView {
                        MainView()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                        
                        JourneysView()
                            .tabItem {
                                Label("Journeys", systemImage: "car")
                            }
                        
                        LeaderboardView()
                            .tabItem {
                                Label("Leaderboards", systemImage: "person.3")
                            }
                        
                        SettingsView()
                            .tabItem {
                                Label("Settings", systemImage: "gear")
                            }
                        
                    }
                }
            }


        }

        
        
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .previewDevice("iPhone 14 Pro")
    }
}
