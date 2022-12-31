//
//  DataService.swift
//  SumpLevels
//
//  Created by Tom Stahl on 12/30/22.
//

import Foundation

class DataService {
    static let shared = DataService()
    
    func fetchWaterLevels(completion: @escaping (Result<[WaterLevel], Error>) -> Void){
        
        var componentURL = URLComponents()
        componentURL.scheme = "https"
        componentURL.host = "sumplevelsapi.azurewebsites.net"
        componentURL.path = "/api/waterlevels"
        
        guard let validURL = componentURL.url else {
            print("URL creation failed")
            return
        }
        
        URLSession.shared.dataTask(with: validURL) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("API Status: \(httpResponse.statusCode)")
            }
            
            guard let validData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do{
                //let json = try JSONSerialization.jsonObject(with: validData, options: [])
                let waterLevels = try JSONDecoder().decode([WaterLevel].self, from: validData)
                completion(.success(waterLevels))
            } catch let serializationError {
                completion(.failure(serializationError))
            }
        }.resume()
        
    }
}
