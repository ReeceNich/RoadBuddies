//
//  SettingsView.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 05/10/2022.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var databaseManager: DatabaseManager
    
    var body: some View {
        NavigationView {
            List {
                Section("Speed Units") {
                    Picker("Select your speed units", selection: $settings.speedUnit) {
                        ForEach(SettingsStore.SpeedUnit.allCases) { speedUnit in
                            HStack {
                                Text("\(speedUnit.rawValue)")
                                Spacer()
                            }
                            .tag(speedUnit)
                        }
                    }
                }
                
                Section("Distance Units") {
                    Picker("Select your distance units", selection: $settings.distanceUnit) {
                        ForEach(SettingsStore.DistanceUnit.allCases) { distanceUnit in
                            HStack {
                                Text("\(distanceUnit.rawValue)")
                                Spacer()
                            }
                            .tag(distanceUnit)
                        }
                    }
                }
                
//                Section("Speed Units") {
//                    ForEach(speedUnits) { speedUnit in
//                        HStack {
//                            Text("\(speedUnit.name)")
//                            Spacer()
//                        }
//                    }
//                }
                
                if (databaseManager.token != nil) {
                    Section("Your Info") {
                        if let user = databaseManager.currentUser {
                            HStack {
                                Text("Name")
                                Spacer()
                                Text(user.name)
                                    .foregroundColor(Color(.systemGray))
                            }
                            HStack {
                                Text("Username")
                                Spacer()
                                Text(user.username)
                                    .foregroundColor(Color(.systemGray))
                            }
                            HStack {
                                Text("Email")
                                Spacer()
                                Text(user.email)
                                    .foregroundColor(Color(.systemGray))
                            }
                        } else {
                            Text("No user present")
                        }
                    }
                    .headerProminence(.increased)
                    .onAppear() {
                        print("getting user info")
                        if let token = databaseManager.token {
                            databaseManager.getUserInfo(token: token) { (data) in
                                print("FETCHING USER INFO FOR SETTINGS PAGE")
                            }
                        }
                    }
                }
                
                
                
                Section("Your Account") {
                    if (databaseManager.token == nil) {
                        NavigationLink(destination: LoginView()) {
                            Button {
                                print("Pressed login")
                            } label: {
                                Text("Login")
                            }
                        }
                        
                        NavigationLink(destination: RegisterView()) {
                            Button {
                                print("Pressed register")
                            } label: {
                                Text("Register")
                            }
                        }
                    } else {
                        Button(action: {
                            print("logout pressed")
                            databaseManager.logoutUser()
                        }, label: {
                            Text("Logout")
                        })
                    }
                }
                
                
                
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsStore())
            .environmentObject(DatabaseManager())
    }
}
