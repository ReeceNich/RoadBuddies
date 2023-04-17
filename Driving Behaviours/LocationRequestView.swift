//
//  LocationRequestView.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 04/10/2022.
//

import SwiftUI

struct LocationRequestView: View {
    @State private var showingPopover = false
    
    var body: some View {
        ZStack {
            Color(.systemBlue).ignoresSafeArea()
            
            VStack {
                Text("RoadBuddies")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding()
                
                Spacer()
                
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 32)
                
                Text("Allow location to proceed?")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("The app requires location to track your vehicle speed, location, acceleration and deceleration...")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                VStack {
                    Button {
                        print("Request location from user")
                        LocationManager.shared.requestLocation()
                    } label: {
                        Text("Allow Location")
                            .padding()
                            .font(.headline)
                            .foregroundColor(Color(.systemBlue))
                            .frame(width: UIScreen.main.bounds.width-64) // allows whole capsule to be pressable.
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding()
                    
                    
                    Button {
                        print("Dismiss location from user")
                        showingPopover = true
                    } label: {
                        Text("Deny Location")
                            .padding()
                            .font(.headline)
                            .foregroundColor(Color(.white))
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .popover(isPresented: $showingPopover) {
                        ZStack {
                            Color(.systemBlue)
                                .ignoresSafeArea()
                            VStack {
                                Text("Your location is required")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Text("The app requires your location to function correctly.")
                                    .multilineTextAlignment(.center)
                                    .font(.headline)
                                    .padding()
                                
                                Text("If you have revoked location services, you will need to go to Settings -> Privacy -> Location Services and enable location.")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                
                                Button {
                                    showingPopover = false
                                } label: {
                                    Text("I Understand")
                                        .padding()
                                        .font(.headline)
                                        .foregroundColor(Color(.systemBlue))
                                        .frame(width: UIScreen.main.bounds.width-64) // allows whole capsule to be pressable.
                                }
                                .frame(width: UIScreen.main.bounds.width)
                                .padding(.horizontal, -32)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .padding()
                            }

                        }
                        
                    }

                }
                .padding(.bottom, 32)
            }
            .foregroundColor(.white)

        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
