//
//  LoginView.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 11/10/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @State var username: String = ""
    @State var password: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var willDismiss = false
    
    var body: some View {
        
        VStack {
            Text("Login to RoadBuddies")
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
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .textContentType(.password)
            
            
            Button {
                databaseManager.loginUser(username: username, password: password) { token in
                    print("GOT TOKEN: \(token)")
                    self.willDismiss = true
                }
                
                
            } label: {
                Text("LOGIN")
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
            
            
            
            
            
        }
        .padding()
        //        .navigationTitle("Login")

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
