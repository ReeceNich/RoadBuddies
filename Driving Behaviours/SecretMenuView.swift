//
//  SecretMenuView.swift
//  Driving Behaviours
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
    @State private var users = [
        User(id: 1, name: "Fred", score: 95),
        User(id: 2, name: "Bob", score: 80),
        User(id: 3, name: "Steve", score: 85)
    ]
    
    @State private var sortOrder = [KeyPathComparator(\User.score)]
    
    
    var body: some View {
        NavigationView {
            List {
                Section("Worst Overall Score") {
                    ForEach(users) { user in
                        HStack {
                            Text("\(user.name)")
                            Spacer()
                            Text("\(user.score) mph")
                                .fontWeight(.semibold)
                        }
                    }
                }
                
                Section("Most Frequent Speeders") {
                    ForEach(users) { user in
                        HStack {
                            Text("\(user.name)")
                            Spacer()
                            Text("\(user.score) G-force")
                                .fontWeight(.semibold)
                        }
                    }
                }
                
                Section("Worst Acceleration Score") {
                    ForEach(users) { user in
                        HStack {
                            Text("\(user.name)")
                            Spacer()
                            Text("\(user.score) G-force")
                                .fontWeight(.semibold)
                        }
                    }
                }
                
                
                
                
            }
            .navigationTitle("Worst Offenders")
        }
    }
}

struct SecretMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SecretMenuView()
    }
}
