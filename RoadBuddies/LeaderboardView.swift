//
//  LeaderboardView.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 09/10/2022.
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    
    
//    @State private var liveSpeeds: DatabaseManager.LiveSpeed? = DatabaseManager.LiveSpeed(dateFetched: 12345678, data: [
//        DatabaseManager.LiveSpeedRow(id: "Test", speed: 99, time: "Never")
//    ])
    
    
    var body: some View {
        NavigationView {
            List {
                Section("All Live Speeds") {
//                    ForEach(liveSpeeds?.data ?? []) { liveSpeedRow in
//                        HStack {
//                            Text("\(liveSpeedRow.id)")
//                            Spacer()
//                            Text("\(liveSpeedRow.speed) mph")
//                                .fontWeight(.semibold)
//                        }
//                    }
                }
            }
            .navigationTitle("Leaderboards")
            
        }
        .onAppear() {
            self.getLiveSpeed()
        }
    }
    
    func getLiveSpeed() {
//        databaseManager.getAllLiveSpeeds() { (data) in
//            self.liveSpeeds = data
//            print("Run")
//        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}





