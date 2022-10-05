//
//  StartView.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 04/10/2022.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        // Show the user auth screen if not authorised
        NavigationView {
            Group {
                if locationManager.userLocation == nil {
                    LocationRequestView()
                    

                } else if let userLocation = locationManager.userLocation {
                    MainView(userLocation: userLocation)
//                        .navigationBarTitle(Text("Driving Behaviours"))
                        

                }
            }


        }

        
        
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .previewDevice("iPhone 13 Pro")
    }
}
