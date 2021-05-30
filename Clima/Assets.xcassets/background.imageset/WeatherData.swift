//
//  WeatherData.swift
//  Clima
//
//  Created by Afnan on 24/05/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    var name: String
    var main: Main
    var weather: [Weather]
}

struct Main: Codable {
    var temp: Float
}

struct Weather: Codable {
    var description: String
    var id: Int
}
