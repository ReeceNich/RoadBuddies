//
//  RegisterView.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 17/03/2023.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var name: String = ""

    @Environment(\.dismiss) private var dismiss
    @State private var willDismiss = false
    
    var body: some View {
        
        VStack {
            Text("Register to RoadBuddies")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            TextField("Name", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .textContentType(.name)
            
            TextField("Username", text: $username)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .textContentType(.username)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .textContentType(.password)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .textContentType(.emailAddress)
            
            
            Button {
                databaseManager.registerUser(username: username, password: password, email: email, name: name) { token in
                    print("GOT TOKEN: \(token)")
                    self.willDismiss = true
                }
                
                
            } label: {
                Text("REGISTER")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
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

    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}