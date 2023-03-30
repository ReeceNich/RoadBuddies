//
//  DatabaseManager.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 09/10/2022.
//

import Foundation


class DatabaseManager: ObservableObject {
    private let baseUrl = "http://192.168.1.166"
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
    @Published var currentJourney: Journey?
    @Published var allJourneys: [Journey]?
    @Published var cachedJourneys: [Journey]?
    
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
        let username: String
        let password: String?
        let email: String
        let name: String
    }
    
    
    struct Journey: Codable, Identifiable, Hashable {
        let journey_id: String
        let user_id: String?
        let time_started: Date
        var time_ended: Date?
        var events: [JourneyEvent]?
        
        var id: String { journey_id }
    }
    
    struct JourneyEvent: Codable, Identifiable, Hashable {
        let journey_id: String
        let event_id: String
        let latitude: Double
        let longitude: Double
        let time: Date
        var speed: Double?
        let is_speeding: Bool
        
        var id: String { event_id }
    }
    
    
    func getUserInfo(token: String, completion: @escaping (User)->Void) {
        let url = URL(string: baseUrl + "/api/users/")
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
                    completion(User(id: "", username: "", password: nil, email: "", name: ""))
                    return
                }
            }
        }.resume()

    }
    
    
    func loginUser(username: String, password: String, completion: @escaping (String)->Void) {
        // Perform user login and get the access token
        let url = URL(string: baseUrl + "/api/users/login")
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
                                self.getUserInfo(token: token) { user in
                                    print("Got user info when login")
                                }
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
    
    func registerUser(username: String, password: String, email: String, name: String, completion: @escaping (Bool)->Void) {
        // Perform user register
        let url = URL(string: baseUrl + "/api/users/register")
        var request = URLRequest(url: url!)
        
        var user = [String : String]()
        user["username"] = username
        user["password"] = password
        user["email"] = email
        user["name"] = name

        let jsonData = try? JSONSerialization.data(withJSONObject: user)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        
        // make register request to API
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(false)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                completion(true)
                return
            }
        }

        task.resume()
        
    }
    
    func logoutUser() {
        self.currentUser = nil
        self.token = nil
    }
    
    
    func getAllJourneys(completion: @escaping ([Journey])->Void) {
        let url = URL(string: baseUrl + "/api/journey/")
        var request = URLRequest(url: url!)
        
        request.setValue(self.token, forHTTPHeaderField: "X-Access-Tokens")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error all Journey: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let jsonString = String(data: try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted), encoding: .utf8) {
                    print(jsonString)
                }
            }
            
            
            do {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(formatter)

                let allJourneys = try decoder.decode([Journey].self, from: data)
                print(allJourneys)
                DispatchQueue.main.async {
                    self.allJourneys = allJourneys
                    completion(allJourneys)
                }
            } catch {
                print("Error decoding all Journey JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    
    
    
    
    func addJourneyToCache(newJourney: Journey) {
        var cachedJourneys = loadCachedJourneys()
        
        // append new elements to the cachedJourneys
        cachedJourneys.append(newJourney)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("cachedJourneys")
        
        // Save the cachedJourneys back to the filesystem
        do {
            let data = try JSONEncoder().encode(cachedJourneys)
            try data.write(to: fileURL)
        } catch {
            print("Error saving cachedJourneys data: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.cachedJourneys = cachedJourneys
        }
    }
    
    // Loads the cached journeys into the published variable self.cachedJourneys
    func loadCachedJourneys() -> [Journey] {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("cachedJourneys")

        var cachedJourneys: [Journey]

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                cachedJourneys = try JSONDecoder().decode([Journey].self, from: data)
            } catch {
                print("Error loading cachedJourneys data: \(error.localizedDescription)")
                cachedJourneys = []
            }
        } else {
            cachedJourneys = []
        }
        
        DispatchQueue.main.async {
            self.cachedJourneys = cachedJourneys
        }
        return cachedJourneys
    }
    
    func resetCachedJourneys() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("cachedJourneys")

        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error removing cachedJourneys data: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.cachedJourneys = nil
        }
    }
    
    
    func uploadCachedJourneys() {
        let cachedJourneys = loadCachedJourneys()
        resetCachedJourneys()
        
        let group = DispatchGroup()
        
        // upload to API
        for journey in cachedJourneys {
            let url = URL(string: baseUrl + "/api/journey/")
            var request = URLRequest(url: url!)
            
            request.setValue(self.token, forHTTPHeaderField: "X-Access-Tokens")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            // encode the journey struct into JSON
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                
                let jsonData = try encoder.encode(journey)
                request.httpBody = jsonData
            } catch {
                print("Error encoding journey data: \(error.localizedDescription)")
            }
            
            group.enter()
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                defer { group.leave() }
                
                if let error = error {
                    // Handle error
                    print("Error making POST request for journey: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse {
                    // Check if the response status code indicates success
                    if response.statusCode == 200 {
                        // The request was successful
                        // Call your function here
                        print("Successfully uploaded journey")
                        
                    } else {
                        // The request was not successful
                        // Handle the error
                        print("POST request uploading journey failed with status code: \(response.statusCode)")
                        // Any journeys that failed to upload, store them again
                        DispatchQueue.main.async {
                            self.addJourneyToCache(newJourney: journey)
                        }
                    }
                }
            }
            task.resume()
        }
        
        group.notify(queue: .main) {
            // Call your function here
            self.getAllJourneys() { (data) in
                print("Got all journeys")
            }
        }
        
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
