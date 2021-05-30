//
//  WeatherManager.swift
//  Clima
//
//  Created by Afnan on 24/05/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didWeatherError(error: Error)
}

struct WeatherManager{
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=c37512bae0b500ab897f5eb93d126dad&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city:String){
        let urlString = "\(weatherUrl)&q=\(city)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude:CLLocationDegrees, longitude:CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let sessionUrl = URLSession(configuration: .default)
            let task = sessionUrl.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    self.delegate?.didWeatherError(error: error!)
                }else{
                    if let safeData = data {
                        if let weather = self.parseJSON(weatherData: safeData){
                            self.delegate?.didUpdateWeather(self,weather: weather)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decoded = try decoder.decode(WeatherData.self, from: weatherData)
//            print(decoded.name)
//            print(decoded.main.temp)
            let id = decoded.weather[0].id
            let name = decoded.name
            let temp = decoded.main.temp
            
            let weather = WeatherModel(weatherId: id, temp: temp, name: name)
            return weather
            print(weather.conditionName)
        }catch{
            print(error)
            self.delegate?.didWeatherError(error: error)
            return nil
        }
    }
}
