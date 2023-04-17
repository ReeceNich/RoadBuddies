//
//  RegisterView.swift
//  RoadBuddies
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
                .multilineTextAlignment(.center)
            
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
                .autocapitalization(.none)
            
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
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            
            Button {
                databaseManager.registerUser(username: username, password: password, email: email, name: name) { response in
                    print("GOT RESPONSE: \(response)")
                    if response {
                        self.willDismiss = true
                    } else {
                        self.willDismiss = false
                    }
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
