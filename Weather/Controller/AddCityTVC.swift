//
//  AddCityTVC.swift
//  Weather
//
//  Created by Rasel Miah on 12/9/19.
//  Copyright © 2019 Winas Inc. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift


class AddCityTVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBarText: UISearchBar!
    var cities: [CityListElement] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarText.delegate = self
        
       navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTap))

    }

}
// MARK: - Search Bar
extension AddCityTVC {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarText.text = ""
        searchBarText.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if let searchText = searchBarText.text {
            cityInfo(Searchvalue: searchText)
        }
    }
    
}

// MARK: - Table view data source
extension AddCityTVC {
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "city", for: indexPath)
        let cityObj = cities[indexPath.row]
        cell.textLabel?.text = cityObj.name
        cell.detailTextLabel?.text = "\(String(describing: cityObj.lat)),  \(cityObj.lon)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        let realm = try! Realm()
        let city = City()
        
        // TODO: - Get name, latitude & longitude
        if let nameOfCity = cell?.textLabel?.text, let latLan = cell?.detailTextLabel?.text {
            let sepletLan = latLan.split(separator: ",")
            if let lat = sepletLan.first, let lon = sepletLan.last {
                
                let latVal = (lat as NSString).doubleValue
                let lonVal = (lon as NSString).doubleValue
                
                city.name = nameOfCity
                city.latitude = latVal
                city.longitude = lonVal
                
                // TODO: - Check duplicate data existence
                let predicate = NSPredicate(format: "name = %@", nameOfCity )
                let cityObj = realm.objects(City.self).filter(predicate)
                
                if cityObj.count == 0 {
                    // MARK: - Insert unique value to City Model
                    try! realm.write {
                        realm.add(city)
                    }
                }
                print(Realm.Configuration.defaultConfiguration.fileURL!) // for database location
                dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
}

// MARK: - Get City Info
extension AddCityTVC {
    func cityInfo(Searchvalue : String)
    {
        let api = GetAPIKey.getAPI(fileName: "apiXU.rsl")
        let  url = "https://api.apixu.com/v1/search.json?key=\(api)&q=\(Searchvalue)"
        
        Alamofire.request(url,method: .get).responseData {
                response in
                if response.result.isFailure, let error = response.result.error {
                    print(error)
                }
                
                if response.result.isSuccess, let value = response.result.value {
                    
                    do {
                        let city = try JSONDecoder().decode([CityListElement].self, from: value)
                        
                        DispatchQueue.main.async {
                            self.cities = city
                            self.tableView.reloadData()
                        }
                        
                    }
                    catch {
                        print(error)
                }
            }
        }
    }
    
}

// MARK: - Done Button
extension AddCityTVC {
    @objc func doneButtonDidTap() {
        dismiss(animated: true, completion: nil)
    }
}

