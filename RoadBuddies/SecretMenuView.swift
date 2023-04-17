//
//  SecretMenuView.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 05/10/2022.
//

import SwiftUI

struct User: Identifiable {
    let id: Int
    var name: String
    var score: Int
}

struct SecretMenuView: View {


    var body: some View {
        NavigationView {
            List {
                Section("Debug Values") {
                    
                }
                
            }
            .navigationTitle("Debug Menu")
        }
    }
}

struct SecretMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SecretMenuView()
    }
}
