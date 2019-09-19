//
//  City.swift
//  Weather
//
//  Created by Rasel Miah on 8/9/19.
//  Copyright © 2019 Winas Inc. All rights reserved.
//

import Foundation
import RealmSwift


class City: Object {
    
    // MARK: - Properties
    @objc dynamic var name = ""
    @objc dynamic var latitude = 0.00
    @objc dynamic var longitude = 0.00

}
