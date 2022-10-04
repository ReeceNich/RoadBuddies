//
//  ContentView.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 04/10/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        // Show the user auth screen if not authorised
        Group {
            if locationManager.userLocation == nil {
                LocationRequestView()
            } else {
                Text("Hello World!")
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
