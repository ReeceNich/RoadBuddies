//
//  FriendsView.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 09/10/2022.
//

import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var pendingFriends: [DatabaseManager.Friend]?
    @State private var allFriends: [DatabaseManager.Friend]?
    
    var body: some View {
        NavigationView {
            List {
                if let friends = allFriends, !friends.isEmpty {
                    Section("All Friends") {
                        ForEach(friends) { friend in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(friend.friend_name)")
                                    Text("\(friend.friend_username)")
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                    Text("Friends Since: \(friend.friend_since!)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FriendsAddView()) {
                        Text("Add")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FriendsManageView()) {
                        if let count = pendingFriends?.count, count > 0 {
                            Text("Manage (\(count))")
                        } else {
                            Text("Manage")
                        }
                    }
                }
            }
            .navigationTitle("Friends")
            .onAppear() {
                updatePendingFriends()
                getAllFriends()
            }
            
        }
    }
    
    func updatePendingFriends() {
        databaseManager.getPendingFriends { pending in
            print("Getting pending")
            self.pendingFriends = pending
            print(pending)
        }
    }
    
    func getAllFriends() {
        databaseManager.getFriends { friends in
            print("Getting all friends")
            self.allFriends = friends
            print(friends)
        }
    }
    
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}





