//
//  HomeView.swift
//  Weather
//
//  Created by Rasel Miah on 8/9/19.
//  Copyright © 2019 Winas Inc. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class HomeView: UITableViewController, DataAdding {

    let realm = try! Realm()
    lazy var cities: Results<City> = { self.realm.objects(City.self) }() // All Cities

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Xib
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        
        // Add Left Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonDidTapped))
        // Add Right Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTap))

        tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "weather"))
    }

}

// MARK: - Add, Edit, Cancel Button Action
extension HomeView {

    @objc func editButtonDidTapped(_ sender: UIBarButtonItem) {

        self.tableView.isEditing = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTapped))

        navigationItem.rightBarButtonItem = nil

    }

    @objc func addButtonDidTap(_ sender: UIBarButtonItem) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let navigationVC = storyBoard.instantiateViewController(withIdentifier: "navigationVC") as? UINavigationController {
            let vc = navigationVC.viewControllers.first as! AddCityTVC
            vc.delegate = self
         present(navigationVC, animated: true)
        }
    }

    @objc private func doneButtonDidTapped() {

        self.isEditing = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTap))

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonDidTapped))

    }

}

// MARK: - Table View Actions
extension HomeView {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfCell = realm.objects(City.self)
        return numberOfCell.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        let city = cities[indexPath.row]
        cell.cityNameLabel.text = city.name
        
        // MARK: - API Call
        let api = GetAPIKey.getAPI(fileName: "darkSkyApi.rsl")
        let url = "https://api.darksky.net/forecast/\(api)/\(city.latitude),\(city.longitude)"
        Alamofire.request(url, method: .get).responseData { response in
            
            if response.result.isFailure, let error = response.result.error {
                print(error)
            }
            
            if response.result.isSuccess, let value = response.result.value {
                do {
                    let weather = try JSONDecoder().decode(WeatherModel.self, from: value)
                    let fh = weather.currently.temperature
                    let cs = String(Int((fh - 32) * (5/9)))
                    
                    // Weather Icon
                    let weatherIcon = weather.currently.icon
                    cell.imageLabel.image = GetIcon.getIcon(weatherIcon: weatherIcon)
                    cell.tempLabel?.text = "\(cs)°C"
                    
                } catch {
                    print(error)
                }
            }
            
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let cell = tableView.cellForRow(at: indexPath) as! WeatherCell
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        if let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC, let nameOfCity = cell.cityNameLabel.text {
            let predicate = NSPredicate(format: "name = %@", nameOfCity)
            let cityObj = realm.objects(City.self).filter(predicate)
            if (cityObj.count) != 0 {
                let city = cityObj.first // get the city
                detailVC.navigationItem.title = city?.name // Navbar Title
                detailVC.getLatitude = city?.latitude // send to Detail View
                detailVC.getLongitude = city?.longitude // send to Detail View
                show(detailVC, sender: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
                let city = cities[indexPath.row]
                try! realm.write {
                    realm.delete(city)
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
        }


    override func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My City"
    }
}

// Reload table
extension HomeView {
    func isAdded(status: Bool) {
        if status {
            tableView.reloadData()
        }
    }
}
