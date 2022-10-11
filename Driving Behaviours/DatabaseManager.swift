//
//  DatabaseManager.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 09/10/2022.
//

import Foundation


class DatabaseManager: ObservableObject {
    private let baseUrl = ""
    @Published var currentUser: User?
    @Published var token: String? {
        willSet {
            print("Setting Token Settings")
            // To store in UserDefaults
            if (newValue != nil) {
                print("Token is - \(newValue ?? "NoTokenNil")")
                UserDefaults.standard.set(newValue, forKey: "token")
            } else {
                print("No Token to Set")
                UserDefaults.standard.removeObject(forKey: "token")
            }
        }
    }
    
    
    init() {
        if let token = UserDefaults.standard.object(forKey: "token") as? String {
            self.token = token
        }
    }
    
    
    
    struct LiveSpeed: Codable {
        let dateFetched: Int
        let data: [LiveSpeedRow]
    }

    struct LiveSpeedRow: Codable, Identifiable {
        let id: String
        let speed: Int
        let time: String
    }
    
    
    struct User: Codable, Identifiable {
        let id: String
        let public_id: String
        let username: String
        let password: String
        let email: String
        let name: String
    }
    
    
    func getUserInfo(token: String, completion: @escaping (User)->Void) {
        let url = URL(string: baseUrl + "/api/user_info")
        var request = URLRequest(url: url!)
        
        request.setValue(token, forHTTPHeaderField: "X-Access-Tokens")
        request.httpMethod = "GET"
        
        print("The request is: \(request)")
//        print(url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let parsedJSON = try jsonDecoder.decode(User.self, from: data)
                    print(parsedJSON)
                    
                    DispatchQueue.main.async {
                        self.currentUser = parsedJSON
                    }
                    
                    completion(parsedJSON)
                    return

                } catch {
                    print("API Database User Info Error: \(error)")
                    completion(User(id: "", public_id: "", username: "", password: "", email: "", name: ""))
                    return
                }
            }
        }.resume()

    }
    
    
    func loginUser(username: String, password: String, completion: @escaping (String)->Void) {
        // Perform user login and get the access token
        let url = URL(string: baseUrl + "/api/login")
        var request = URLRequest(url: url!)
        
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        
        // make login request to API
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let data = data {
                
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: String] {
                        // try to read out a string array
                        if let token = json["token"] {
                            
                            DispatchQueue.main.async {
                                self.token = token
                            }
                            
                            completion(token)
                            return
                        }
                    }
                }
            } catch {
                print(error)
//                completion("")
                return
            }
        }.resume()
        
    }
    
    func logoutUser() {
        self.currentUser = nil
        self.token = nil
    }
    
    
    
    func getAllLiveSpeeds(completion: @escaping (LiveSpeed)->Void) {
        let url = baseUrl + "/api/livespeed"
        
//        print(url)
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(LiveSpeed.self, from: data)
//                        print(parsedJSON)

                        completion(parsedJSON)
                        return
 
                    } catch {
                        print("API Database Speed Limit Error: \(error)")
                        completion(LiveSpeed(dateFetched: -1, data: []))
                        return
                    }
                }
            }.resume()
        }
    }
    
    
    
}
