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
//    var userLocation: CLLocation
    
    @State private var showingSecretPopover = false
    
    let streetManager = StreetDataManager()
    @State private var streetName: String = ""
    @State private var streetRef: String = ""
    @State private var maxSpeed: String = ""
    @State private var maxSpeedVal: Int = -1
    @State private var maxSpeedUnit: SettingsStore.SpeedUnit = .kmh
    @State private var streetFetchedDate: Date = Date.now
//    @State private var streetTags: StreetDataManager.Tags = StreetDataManager.Tags(name: nil, ref: nil, maxspeed: nil)
    @State private var apiCounter = 0
    @State private var cancelAsync = false
    
    
    // Recording Location Data variables
    @State private var isRecording = false
    @State private var count = 0
    
    var userLocationCoordinate: CLLocationCoordinate2D {
        return locationManager.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    var userLocationSpeed: CLLocationSpeed {
        return locationManager.userLocation?.speed ?? CLLocationSpeed(0)
    }
    
    
    var body: some View {
        ScrollView {
            ZStack {
                
//                Text("Psst... hold the speed limit sign!")
//                    .padding(.all, 5)
//                    .padding(.horizontal, 40)
//                    .foregroundColor(.white)
//                    .background(Color(.systemGray))
//                    .clipShape(Capsule())
//                    .position(x: UIScreen.main.bounds.width/2, y: -200)
                
                
                ZStack {
                    Map(coordinateRegion: $locationManager.region, showsUserLocation: true, userTrackingMode: $mapTracking)
                        .allowsHitTesting(false)
                        .frame(height: 250)
                    
                    
                    VStack {
                        Spacer()
                        HStack {
                            VStack {
                                Text("\(userLocationSpeed > 0 ? settings.convertSpeed(to: settings.speedUnit, value: userLocationSpeed) : 0, specifier: "%.0f")")
                                    .font(Font.title)
                                    .fontWeight(.heavy)
                                    
                                    .foregroundColor(Color(.label))
                                Text("\(settings.speedUnit.rawValue)")
                            }
                            .padding(.vertical, 15)
                            .padding(.horizontal, 20)
                            .background(
                                
                                settings.convertSpeed(to: maxSpeedUnit, value: userLocationSpeed) <= Double(maxSpeedVal) || Double(maxSpeedVal) <= 0 ? Color(.systemGray6) : Color(.systemRed)
                            )
                        
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(.systemGray3), lineWidth: 2)
                            )
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                    }
                    
                    VStack {
                        Spacer()
                        HStack() {
                            Spacer()
                            
                            SpeedLimitSign(limit: Int(settings.convertSpeed(to: settings.speedUnit, value: settings.convertSpeed(from: self.maxSpeedUnit, to: .ms, value: Double(maxSpeedVal)))), unit: settings.speedUnit)
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
                isRecording.toggle()
                print("Pressed Go!")
                print("isRecording = " + String(isRecording))
                if isRecording {
                    print("Start recording!")
                    self.startRecording()
                }
            } label: {
                Text(isRecording ? "Stop" : "Go!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(30)
                    .foregroundColor(.white)
                    
            }
            .background(isRecording ? Color(.systemRed) : Color(.systemBlue))
            .clipShape(Circle())
            .padding(.top)
            
            VStack(alignment: .leading) {
                if streetName != "" {
                    Text("\(streetName)")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                
                if streetRef != "" {
                    Text("\(streetRef)")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                
                VStack(alignment: .leading) {
                    Text("DEBUG VALUES")
                        .font(.title2)
                    Text("Lat: \(userLocationCoordinate.latitude)")
                    Text("Lon: \(userLocationCoordinate.longitude)")
                    Text("Current Speed: \(userLocationSpeed) ms")
                    Text("Street Name: \(streetName)")
                    Text("Max Speed: \(maxSpeed)")
                    Text("Max Speed Val: \(maxSpeedVal)")
                    Text("Max Speed Unit: \(maxSpeedUnit.rawValue)")
                    VStack(alignment: .leading) {
                        Text("API Fetched: \(apiCounter) times")
                        Text("API Fetched: \(streetFetchedDate.description)")
                        Text("Is Recording: \(isRecording.description)")
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.systemGray3), lineWidth: 2)
                )
            }
            .padding()
            .frame(
                maxWidth: .infinity,
                alignment: .topLeading
            )
            
            
            

            
        }
        .ignoresSafeArea(edges: .top)
        .onAppear() {
            print("DEBUG: MAIN VIEW APPEARED")
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear() {
            print("DEBUG: MAIN VIEW DISAPPEARED")
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    
    func startRecording() {
        DispatchQueue.global(qos: .background).async {
            while isRecording {
                getStreetTags()
                recordDataToDatabase()
                // Time to wait until the next call.
                sleep(5)
            }
        }
    }
    
    func getStreetTags() {
        print("-----> callGetStreetTags")
        streetManager.getStreetTags(lat: userLocationCoordinate.latitude, lon: userLocationCoordinate.longitude, around: 25) { (data) in
            self.maxSpeed = data.maxspeed ?? ""
            self.maxSpeedVal = data.maxspeedval ?? -1
            self.maxSpeedUnit = data.maxspeedunit ?? .kmh
            self.streetName = data.name ?? ""
            self.streetRef = data.ref ?? ""

            self.streetFetchedDate = data.fetchedDate ?? Date.distantPast
            self.apiCounter += 1
            print("-----> Updated Street Variables, prepare to run again")
        }
    }
    
    func recordDataToDatabase() {
        print("Recording data to database")
    }
    
    
//    func callGetStreetTags() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            print("-----> callGetStreetTags")
//            streetManager.getStreetTags(lat: userLocationCoordinate.latitude, lon: userLocationCoordinate.longitude, around: 25) { (data) in
//                self.maxSpeed = data.maxspeed ?? ""
//                self.maxSpeedVal = data.maxspeedval ?? -1
//                self.maxSpeedUnit = data.maxspeedunit ?? .kmh
//                self.streetName = data.name ?? ""
//                self.streetRef = data.ref ?? ""
//
//                self.streetFetchedDate = data.fetchedDate ?? Date.distantPast
//                self.apiCounter += 1
//                print("--> Updated Street Variables, prepare to run again")
//
//                if !self.cancelAsync {
//                    callGetStreetTags()
//                }
//            }
//        }
//    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SettingsStore())
    }
}
