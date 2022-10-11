//
//  SettingsView.swift
//  Driving Behaviours
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
                
//                Section("Speed Units") {
//                    ForEach(speedUnits) { speedUnit in
//                        HStack {
//                            Text("\(speedUnit.name)")
//                            Spacer()
//                        }
//                    }
//                }
                
                Section("Your Info") {
                    if let user = databaseManager.currentUser {
                        Text(user.name)
                        Text(user.email)
                        Text(user.username)
                    } else {
                        Text("No user present")
                    }
                }
                .onAppear() {
                    print("getting user info")
                    if let token = databaseManager.token {
                        databaseManager.getUserInfo(token: token) { (data) in
                            print("FETCHING USER INFO FOR SETTINGS PAGE")
                        }
                    }
                }
                
                
                
                Section("Your Account") {
                    if (databaseManager.currentUser == nil) {
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
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
