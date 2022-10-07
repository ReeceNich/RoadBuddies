//
//  MainView.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 05/10/2022.
//

import SwiftUI
import MapKit

struct MainView: View {
    @EnvironmentObject var settings: SettingsStore
    @ObservedObject var locationManager = LocationManager.shared
    @State private var mapTracking: MapUserTrackingMode = .follow
    var userLocation: CLLocation
    
    @State private var showingSecretPopover = false
    
    let streetManager = StreetDataManager()
    @State private var streetName: String = ""
    @State private var streetRef: String = ""
    @State private var maxSpeed: String = ""
    @State private var maxSpeedVal: Int = -1
    @State private var maxSpeedUnit: SettingsStore.SpeedUnit = .kmh
//    @State private var streetTags: StreetDataManager.Tags = StreetDataManager.Tags(name: nil, ref: nil, maxspeed: nil)
    
    
    var body: some View {
        ScrollView {
            ZStack {
                
                Text("Psst... hold the speed limit sign!")
                    .padding(.all, 5)
                    .padding(.horizontal, 40)
                    .foregroundColor(.white)
                    .background(Color(.systemGray))
                    .clipShape(Capsule())
                    .position(x: UIScreen.main.bounds.width/2, y: -200)
                
                
                ZStack {
                    Map(coordinateRegion: $locationManager.region, showsUserLocation: true, userTrackingMode: $mapTracking)
                        .allowsHitTesting(false)
                        .frame(height: 250)
                    
                    
                    VStack {
                        Spacer()
                        HStack {
                            Text("\(userLocation.speed > 0 ? settings.convertSpeed(to: settings.speedUnit, value: userLocation.speed) : 0, specifier: "%.0f") \(settings.speedUnit.rawValue)")
                                .font(Font.title)
                                .fontWeight(.heavy)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 20)
                                .foregroundColor(Color(.label))
                            
                                .background(
                                    
                                    settings.convertSpeed(to: maxSpeedUnit, value: userLocation.speed) < Double(maxSpeedVal) || Double(maxSpeedVal) <= 0 ? Color(.systemGray6) : Color(.systemOrange))
                            
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                    }
                    
                    VStack {
                        Spacer()
                        HStack() {
                            Spacer()
                            
                            SpeedLimitSign(limit: maxSpeedVal, currentSpeedInMs: userLocation.speed)
                                .simultaneousGesture(LongPressGesture(minimumDuration: 2).onEnded { _ in
                                    print("Secret Long Press Action!")
                                    showingSecretPopover = true
                                })
                                .popover(isPresented: $showingSecretPopover) {
                                    SecretMenuView()
                                }
                            
                        }
                        .padding()
                    }
                    
                }
            }
            
            Button {
                print("Pressed Go!")
            } label: {
                Text("Go!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(30)
                    .foregroundColor(.white)
                    
            }
            .background(Color(.systemBlue))
            .clipShape(Circle())
            .padding()
            
            
            Text("Lat: \(userLocation.coordinate.latitude)")
            Text("Lon: \(userLocation.coordinate.longitude)")
            Text("Speed: \(userLocation.speed) ms")
            Text("Street Name: \(streetName)")
            Text("Max Speed: \(maxSpeed)")
            Text("Max Speed Val: \(maxSpeedVal)")
            Text("Max Speed Unit: \(maxSpeedUnit.rawValue)")

                            
            Spacer()
            
        }
        .ignoresSafeArea(edges: .top)
        .onAppear() {
            callGetStreetTags()
        }
        
    }
    
    func callGetStreetTags() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("-----> callGetStreetTags")
            streetManager.getStreetTags(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude, around: 35) { (data) in
                self.maxSpeed = data.maxspeed ?? ""
                self.maxSpeedVal = data.maxspeedval ?? -1
                self.maxSpeedUnit = data.maxspeedunit ?? .kmh
                self.streetName = data.name ?? ""
                self.streetRef = data.ref ?? ""
                
                print("--> Updated Street Variables, prepare to run again")
                callGetStreetTags()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userLocation: CLLocation(latitude: 51.492404, longitude: -2.541713))
            .environmentObject(SettingsStore())
    }
}
