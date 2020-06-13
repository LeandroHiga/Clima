//
//  WeatherManager.swift
//  Clima
//
//  Created by Lean Caro on 25/05/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

//Create protocol that will adopt then WeatherViewController
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    //URL without city name
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=3d994e76b144957e6a7d0369c4a4f925&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    //Fetch weather based on entered city name
    func fetchWeather(cityName: String) {
        //Add city name to url
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    //Fetch weather based on current location
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
         //Add city name to url
         let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
         performRequest(with: urlString)
     }
     
    
    //Networking that fetch ive data from Open Weather
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create URL Session
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                //Check if there is an error
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    //If there is an error, exit out of the function
                    return
                }
                //Check if data is nil
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    //Parse weather into a Swift object
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id //Weather ID
            let name = decodedData.name        //City Name
            let temp = decodedData.main.temp   //Temperature
           
            //Create weather object
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
