//
//  WeatherModel.swift
//  Clima
//
//  Created by Lean Caro on 27/05/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    //Computed property based on the condition ID
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    //Computed property (convert temperature to a String with a single decimal place
    var temperatureString: String {
        let tempAsString = String(format: "%.1f", temperature)
        return tempAsString
    }
}
