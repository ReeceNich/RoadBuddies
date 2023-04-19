//
//  StartView.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 04/10/2022.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var selectedTab = 0
    @State private var pendingFriends: Int = 0
    
    var body: some View {
        // Show the user auth screen if not authorised
        NavigationView {
            Group {
                if locationManager.userLocation == nil {
                    LocationRequestView()
                    

//                } else if let userLocation = locationManager.userLocation {
                } else {
                    
                    TabView(selection: $selectedTab) {
                        MainView()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                            .tag(0)
                        
                        JourneysView()
                            .tabItem {
                                Label("Journeys", systemImage: "car")
                            }
                            .tag(1)
                        
                        FriendsView()
                            .tabItem {
                                Label("Friends", systemImage: "person.3")
                            }
                            .tag(2)
                            .badge(self.pendingFriends)
                        
                        SettingsView()
                            .tabItem {
                                Label("Settings", systemImage: "gear")
                            }
                            .tag(3)
                        
                    }
                    .onChange(of: selectedTab) { newValue in
                        databaseManager.getPendingFriends { pending in
                            self.pendingFriends = pending.count
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
