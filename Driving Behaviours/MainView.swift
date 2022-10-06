//
//  MainView.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 05/10/2022.
//

import SwiftUI
import MapKit

struct MainView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @State private var mapTracking: MapUserTrackingMode = .follow
    var userLocation: CLLocation
    
    @State private var showingSecretPopover = false
    
    
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
                    
                    
                    
                    Text("\(userLocation.speed > 0 ? userLocation.speed : 0, specifier: "%.0f") ms")
                        .font(Font.callout)
                        .fontWeight(.bold)
                        .padding(.all, 10)
                        .foregroundColor(.black)
                    
                        .background(Color(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom, 30)
                    
                    
                    VStack {
                        Spacer()
                        HStack() {
                            Spacer()
                            
                            SpeedLimitSign(limit: 70, currentSpeed: 65)
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
            
            
            Text("Hello World!")
            Text("Lat: \(userLocation.coordinate.latitude)")
            Text("Lon: \(userLocation.coordinate.longitude)")
            Text("Speed: \(userLocation.speed) ms")
            
            Spacer()
            
        }
        .ignoresSafeArea(edges: .top)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userLocation: CLLocation(latitude: 50, longitude: -1))
    }
}
