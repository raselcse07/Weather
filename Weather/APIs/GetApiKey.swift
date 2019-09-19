//
//  GetApiKey.swift
//  Weather
//
//  Created by Rasel Miah on 20/9/19.
//  Copyright © 2019 Winas Inc. All rights reserved.
//

import Foundation

struct GetAPIKey {
    static func getAPI(fileName: String) -> String {
        let file = fileName
        var apiKey: String = ""
        if let path = Bundle.main.path(forResource: file, ofType: nil) {
            apiKey = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        }
        return apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
