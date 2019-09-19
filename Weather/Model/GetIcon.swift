//
//  GetIcon.swift
//  Weather
//
//  Created by Rasel Miah on 12/9/19.
//  Copyright © 2019 Winas Inc. All rights reserved.
//

import Foundation
import UIKit

struct GetIcon {
    static func getIcon(weatherIcon: String) -> UIImage {
        var image: UIImage?
        
        if  weatherIcon == "clear-day"{
            image = UIImage(named: "sun.png")!
        } else if weatherIcon == "rain" {
            image = UIImage(named:"rain.png")!
        } else if weatherIcon == "snow" {
            image = UIImage(named:"snow.png")!
        } else if weatherIcon == "sleet" {
            image = UIImage(named:"sleet.png")!
        } else if weatherIcon == "wind" {
            image = UIImage(named:"wind.png")!
        } else if weatherIcon == "fog" {
            image = UIImage(named:"foggy.png")!
        } else if weatherIcon == "cloudy" {
            image = UIImage(named:"clouds.png")!
        } else if weatherIcon == "partly-cloudy-day" {
            image = UIImage(named:"partly-cloudy.png")!
        } else if weatherIcon == "clear-night" {
            image = UIImage(named:"moon.png")!
        } else if weatherIcon == "partly-cloudy-night" {
            image = UIImage(named:"partly-cloudy-night.png")!
        }
        
        return image!
    }
    
    static func resturantStatus(status: Bool) -> UIImage {
        var image: UIImage?
        if status {
            image = UIImage(named:"open-sign.png")!
        } else if !status {
            image = UIImage(named:"close-sign.png")!
        }
        return image!
    }
}
