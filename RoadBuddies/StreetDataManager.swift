//
//  StreetDataManager.swift
//  RoadBuddies
//
//  Created by Reece Nicholls on 06/10/2022.
//

import Foundation

class StreetDataManager {
    
    static var previousStreetID: Int = -1
    
    struct maxSpeedModel: Codable {
        var elements: [Element]
    }
    
    struct Element: Codable {
        let type: String
        let id: Int
        let nodes: [Int]
        var tags: Tags
    }
    
    struct Tags: Codable {
        let name: String?
        let ref: String?
        let maxspeed: String?
        var maxspeedunit: SettingsStore.SpeedUnit?
        var maxspeedval: Int?
        var fetchedDate: Date? = Date.now
    }
    
    struct Speed: Codable {
        var val: Int
        var unit: SettingsStore.SpeedUnit = .kmh
    }

    
    func getStreetTags(lat: Double, lon: Double, around: Double = 25.0, completion: @escaping (Tags)->Void) {
        let url = "https://overpass-api.de/api/interpreter?data=[out:json];way(around:\(around),\(lat),\(lon))[maxspeed];out;"
        
//        print(url)
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(maxSpeedModel.self, from: data)
//                        print(parsedJSON)
                        
                        // If the previous Street ID is found in the new Street data, continue using the existing data for that street.
                        // This will minimise providing the incorrect street details e.g., on overpasses or nearby streets.
                        for var element in parsedJSON.elements {
                            if element.id == StreetDataManager.previousStreetID {
                                // They are potentially still on the same street. Continue using this street.
                                print("Found existing street - ID: \(element.id)")
                                StreetDataManager.previousStreetID = element.id
                                
                                // Extract speed details
                                let speed = self.determineSpeedValAndUnit(from: element.tags.maxspeed ?? "")
                                
                                element.tags.maxspeedunit = speed.unit
                                element.tags.maxspeedval = speed.val
                                element.tags.fetchedDate = Date.now
                                
                                completion(element.tags)
                                return
                            }
                        }
                        
                        for var element in parsedJSON.elements {
                            if (element.tags.maxspeed != nil) {
                                StreetDataManager.previousStreetID = element.id
                                
                                // Extract speed details
                                let speed = self.determineSpeedValAndUnit(from: element.tags.maxspeed ?? "")
                                
                                element.tags.maxspeedunit = speed.unit
                                element.tags.maxspeedval = speed.val
                                element.tags.fetchedDate = Date.now
                                
                                completion(element.tags)
                                return
                            }
                        }
                        
                        // API Found no streets.
                        StreetDataManager.previousStreetID = -1
                        completion(Tags(name: nil, ref: nil, maxspeed: nil, maxspeedunit: .kmh, maxspeedval: -1, fetchedDate: Date.now))
                        return
                        
                        
                    } catch {
                        print("API Speed Limit Error: \(error)")
                        completion(Tags(name: "Error - API", ref: "Error - API", maxspeed: "Error - API", maxspeedunit: .kmh, maxspeedval: -1, fetchedDate: Date.now))
                    }
                }
            }.resume()
        }
    }
    
    // https://wiki.openstreetmap.org/wiki/Key:maxspeed
    func determineSpeedValAndUnit(from raw: String) -> Speed {
        let split = raw.components(separatedBy: " ")
        
        let val = Int(split[0]) ?? -1
        let unit = (split.count > 1 ? SettingsStore.SpeedUnit(rawValue: split[1]) : SettingsStore.SpeedUnit.kmh) ?? SettingsStore.SpeedUnit.kmh
        
        return Speed(val: val, unit: unit)
        
    }
    
}
