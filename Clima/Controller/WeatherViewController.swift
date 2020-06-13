//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    //Responisble for getting hold of current GPS locaton
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set this class as the delegate for locationManager
        locationManager.delegate = self
        //Ask user for permission to use location services while using app
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //Set this class as the delegate for weatherManager
        weatherManager.delegate = self
        
        searchTextField.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        //Dismiss keyboard when search button is pressed
        searchTextField.endEditing(true)
    }
    
    //Execute when the keyboard's return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Dismiss keyboard
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        ///Let you finish editing if the field is not nil
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter location"
            return false
        }
    }
    
    //Execute when any text field ends editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Use searchTextField.text to get the weather for that city
        if let city = searchTextField.text {
            //Pass city name as an argument
            weatherManager.fetchWeather(cityName: city)
        }
        
        //Reset text field to blank
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        //Use of DispatchQueue
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString //Update temperature label
            self.conditionImageView.image = UIImage(systemName: weather.conditionName) //Update condition image
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

