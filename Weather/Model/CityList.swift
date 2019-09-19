//
//  CityList.swift
//  Weather
//
//  Created by Rasel Miah on 9/9/19.
//  Copyright © 2019 Winas Inc. All rights reserved.
//

import Foundation

// MARK: - CityListElement
struct CityListElement: Codable {
    let id: Int
    let name: String
    let lat, lon: Double
    let url: String
}


typealias CityList = [CityListElement]
