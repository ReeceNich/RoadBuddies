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
    
    var body: some View {
        ScrollView {
            ZStack {

                
                
                ZStack {
                    Map(coordinateRegion: $locationManager.region, showsUserLocation: true, userTrackingMode: $mapTracking)
                        .allowsHitTesting(false)
                        .frame(height: 250)
                    
                    
                    
                    Text("\(userLocation.speed > 0 ? userLocation.speed*2.237 : 0, specifier: "%.0f") mph")
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
                        }
                        .padding()
                    }
                    
                }
            }
            
            Button {
                print("Go!")
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
