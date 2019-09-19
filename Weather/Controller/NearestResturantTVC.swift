//
//  NearestResturantTVC.swift
//  Weather
//
//  Created by Rasel Miah on 19/9/19.
//  Copyright © 2019 Winas Inc. All rights reserved.
//

import UIKit
import Alamofire

class NearestResturantTVC: UITableViewController {

    var getLatitude: Double?
    var getLongitude: Double?
    var nearestResturant: GooglePlacesResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportingFunction()
        apiCall()
    }
}

 // MARK: - Table view data source
extension NearestResturantTVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearestResturant?.results?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResturantCell", for: indexPath) as! ResturantCell
        if let nameOfResturant = nearestResturant?.results?[indexPath.row].name, let address = nearestResturant?.results?[indexPath.row].address, let currentStatus = nearestResturant?.results?[indexPath.row].openingHours {
            
            cell.nameLabel.text = nameOfResturant
            cell.addressLabel.text = address
            cell.imageLabel.image = GetIcon.resturantStatus(status: currentStatus.isOpen)
    
        }
        return cell
    }
    
}

// MARK: - Custom Function
extension NearestResturantTVC {
    
    private func supportingFunction() {
        
        // Back Button
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.title = "Nearest Resturant"
        
        // Register Xib
        tableView.register(UINib(nibName: "ResturantCell", bundle: nil), forCellReuseIdentifier: "ResturantCell")
        
        tableView.tableFooterView = UIView()
        
    }
    
    private func getResturantData(data: GooglePlacesResponse){
        nearestResturant = data
        tableView.reloadData()
    }
    
    private func apiCall(){
        // API Call
        let api = GetAPIKey.getAPI(fileName: "googleApi.rsl")
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(getLatitude ?? 0.00),\(getLongitude ?? 0.00)&radius=1500&type=restaurant&key=\(api)"
        
        Alamofire.request(url, method: .get).responseData { response in
            
            if response.result.isFailure, let error = response.result.error {
                print(error)
            }
            
            if response.result.isSuccess, let value = response.result.value {
                do {
                    let resturantList = try JSONDecoder().decode(GooglePlacesResponse.self, from: value)
                    self.getResturantData(data: resturantList)
                } catch {
                    print(error)
                }
            }
        }
    }
}
