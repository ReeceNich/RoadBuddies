//
//  FriendsManageView.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 19/04/2023.
//

import SwiftUI

struct FriendsManageView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var pendingFriends: [DatabaseManager.Friend]?// = [DatabaseManager.Friend(friend_username: "Test4", friend_name: "Test 4", friend_requested: Date.now)]
    @State private var allFriends: [DatabaseManager.Friend]?// = [DatabaseManager.Friend(friend_username: "Test1", friend_name: "Test 1", friend_requested: Date.now, friend_since: Date.now), DatabaseManager.Friend(friend_username: "Test2", friend_name: "Test 2", friend_requested: Date.now, friend_since: Date.now), DatabaseManager.Friend(friend_username: "Test3", friend_name: "Test 3", friend_requested: Date.now, friend_since: Date.now)]
    
    var body: some View {
        List {
            if let pending = pendingFriends, !pending.isEmpty {
                Section("Pending Friend Requests") {
                    ForEach(pending) { friend in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(friend.friend_name)")
                                Text("\(friend.friend_username)")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                Text("Requested: \(friend.friend_requested!)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            HStack {
                                Button("Reject") {
                                    // Reject friend request
                                    print("Press reject")
                                    databaseManager.removeFriend(friend_username: friend.friend_username) { success in
                                        // Rejected friend request
                                        updatePendingFriends()
                                    }
                                }
                                .buttonStyle(.borderless)
                                .foregroundColor(.red)
                                
                                Button("Accept") {
                                    // Accept friend request
                                    print("Press accept")
                                    databaseManager.acceptFriend(friend_username: friend.friend_username) { success in
                                        // Accepted friend request
                                        updatePendingFriends()
                                    }
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
            }
            
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
                    .onDelete(perform: deleteFriend)
                }
            }
        }
        .navigationTitle("Manage Friends")
        .onAppear() {
            updatePendingFriends()
            getAllFriends()
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
    
    func deleteFriend(at offsets: IndexSet) {
        print("Offsets \(offsets)")
        
        for index in offsets {
            let friend = self.allFriends![index]
            
            print("Offsets \(friend.friend_username)")
            // use friend's properties or methods here
            databaseManager.removeFriend(friend_username: friend.friend_username) { success in
                if success {
                    print("Was a success")
//                    self.allFriends!.remove(atOffsets: offsets)
                }
            }
        }
    }
}

struct FriendsManageView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsManageView()
            .environmentObject(DatabaseManager())
    }
}
