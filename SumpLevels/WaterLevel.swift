//
//  WaterLevel.swift
//  SumpLevels
//
//  Created by Tom Stahl on 12/30/22.
//

import Foundation

struct WaterLevel: Codable {
    var id: Int
    var loggedTime: String
    var measurement: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case loggedTime = "LoggedTime"
        case measurement = "Measurement"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.loggedTime = try container.decode(String.self, forKey: .loggedTime)
        // this is how you do a property that might be nil
        self.measurement = try container.decode(Double.self, forKey: .measurement)
    }
}
