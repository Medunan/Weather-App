//
//  ClimaData.swift
//  Clima
//
//  Created by Medunan on 14/09/22.
//

import UIKit

struct ClimaData: Codable {
    let name : String
    let main : Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather : Codable {
    let description : String
    let id : Int
}
