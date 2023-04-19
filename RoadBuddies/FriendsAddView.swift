//
//  FriendsAddView.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 19/04/2023.
//

import SwiftUI

struct FriendsAddView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @State var username: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var willDismiss = false
    @State private var wasSuccess = true
    
    var body: some View {
        VStack {
            Text("Add a Friend")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
            
            TextField("Username", text: $username)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .textContentType(.username)
                .autocapitalization(.none)
            
            Button {
                databaseManager.addFriend(friend_username: username) { success in
                    if success {
                        self.willDismiss = true
                    } else {
                        self.wasSuccess = false
                    }
                }
            } label: {
                Text("ADD")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 25)
                    .background(Color(.systemBlue))
                    .cornerRadius(15.0)
            }
            .onChange(of: willDismiss) { newValue in
                if newValue {
                    dismiss()
                }
            }
            
            if !wasSuccess {
                Text("Could not add the friend...")
                    .padding()
            }
            
        }
        .padding()
        //
    }
}

struct FriendsAddView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsAddView()
            .environmentObject(DatabaseManager())
    }
}
