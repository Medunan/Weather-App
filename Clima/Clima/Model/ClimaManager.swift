//
//  ClimaManager.swift
//  Clima
//
//  Created by Medunan on 04/09/22.
//
// use ClimaManager to parse the data using ClimaData and store the values in ClimaModel and use ClimaManagerDelegate to send the data around

import Foundation
import CoreLocation
                                                       // creating the protocol to send the parsed data to weatherVC
protocol ClimaManagerDelegate {
    func didUpdateWeather(_ climaManager:ClimaManager, weather: ClimaModel)
    func didFailWithError(error: Error)
}

struct ClimaManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ed32e3c3d45f868a3b3b90141a652349&units=metric"
    
    var delegate: ClimaManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)         //delegate function to                                                                       pass the data
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> ClimaModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData =  try decoder.decode(ClimaData.self, from: weatherData)
            
            let temp = decodedData.main.temp
            let id   = decodedData.weather[0].id
            let name = decodedData.name
            
            let clima = ClimaModel(conditionId: id, cityName: name, temperature: temp)
            return clima
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}

