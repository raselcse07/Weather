//
//  DetailVC.swift
//  Weather
//
//  Created by Rasel Miah on 12/9/19.
//  Copyright © 2019 Winas Inc. All rights reserved.
//

import UIKit
import Alamofire

class DetailVC: UIViewController, UICollectionViewDataSource, UITableViewDataSource {
    
    

    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentTempIcon: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dataOfCollectionView: UICollectionView!
    @IBOutlet weak var tableViewforWeekly: UITableView!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    var getLatitude: Double?
    var getLongitude: Double?
    
    var weatherInfo: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportingFunc()
        apiCall()

    }
    
    @IBAction func NearestResturantButtonDidTap(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        
        let nearestResturantView = storyBoard.instantiateViewController(withIdentifier: "NearestResturantTVC") as! NearestResturantTVC
        
        nearestResturantView.getLatitude = self.getLatitude
        nearestResturantView.getLongitude = self.getLongitude
        
        show(nearestResturantView, sender: nil)
    }
    
}

// MARK: - Table View
extension DetailVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInfo?.daily.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewforWeekly.dequeueReusableCell(withIdentifier: "WeeklyCell", for: indexPath) as! WeeklyCell
        
        cell.dayName.text = dateTimeFormat(DateTime: weatherInfo?.daily.data[indexPath.row].time,dateStyle: nil, timeStyle: nil, dateFormat: "EEEE")
        if let minTemp = weatherInfo?.daily.data[indexPath.row].temperatureMin, let maxTemp = weatherInfo?.daily.data[indexPath.row].temperatureMax, let icon = weatherInfo?.daily.data[indexPath.row].icon {
            cell.minTemp.text = String(Int((minTemp - 32) * (5/9))) + "°C"
            cell.maxTemp.text = String(Int((maxTemp - 32) * (5/9))) + "°C"
            cell.icon.image = GetIcon.getIcon(weatherIcon: icon)
        }
        return cell
      
        }
    
}

// MARK: - Collection View
extension DetailVC {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherInfo?.hourly.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dataOfCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        // Style Cell
        roundCell(cell: cell)
        
        if let temp = weatherInfo?.hourly.data[indexPath.row].temperature, let icon = weatherInfo?.hourly.data[indexPath.row].icon, let date = weatherInfo?.hourly.data[indexPath.row].time {
            
            cell.hrTemp.text = String(Int((temp - 32) * (5/9))) + "°C"
            cell.hrTime.text = dateTimeFormat(DateTime: date, dateStyle: nil, timeStyle: .short,dateFormat: nil)
            cell.hrImageIcon.image = GetIcon.getIcon(weatherIcon: icon)
        }
        return cell
    }
}

// MARK: - Custom Function
extension DetailVC {
    
    // get weather data
    func getData(data: WeatherModel) {
        weatherInfo = data
        dataOfCollectionView.reloadData()
        tableViewforWeekly.reloadData()

    }
    

    
    // date time format
    func dateTimeFormat(DateTime: Int?, dateStyle: DateFormatter.Style?, timeStyle: DateFormatter.Style?, dateFormat: String?) -> String {
        let dateFormatter = DateFormatter()
        
        if let dStyle = dateStyle {
            dateFormatter.dateStyle = dStyle
        }
        
        if let dFormat = dateFormat {
            dateFormatter.dateFormat = dFormat
        }
        
        if let tStyle = timeStyle {
            dateFormatter.timeStyle = tStyle
        }
        
        let date = Date(timeIntervalSince1970: TimeInterval((DateTime ?? 0)))
        return dateFormatter.string(from: date)
    }
    
    // get current data
    private func getCurrentData() {
        let fh = weatherInfo?.currently.temperature ?? 0.00
        let cs = String(Int((fh - 32) * (5/9)))
        currentTempLabel.text = "\(cs)°C"
        summaryLabel.text = weatherInfo?.currently.summary
        if let icon = weatherInfo?.currently.icon, let day = weatherInfo?.daily.data.first?.time {
            currentTempIcon.image = GetIcon.getIcon(weatherIcon: icon)
            dayLabel.text = dateTimeFormat(DateTime: day, dateStyle: nil, timeStyle: nil, dateFormat: "EEEE")
        }
    }
    
    // supporting function
    private func supportingFunc() {
        dataOfCollectionView.dataSource = self
        tableViewforWeekly.dataSource = self
        tableViewforWeekly.tableFooterView = UIView()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        tableViewforWeekly.register(UINib(nibName: "WeeklyCell", bundle: nil), forCellReuseIdentifier: "WeeklyCell")
    }
    
    // api call
    func apiCall() {
        let api = GetAPIKey.getAPI(fileName: "darkSkyApi.rsl")
        let url = "https://api.darksky.net/forecast/\(api)/\(getLatitude ?? 0.00),\(getLongitude ?? 0.00)"
        Alamofire.request(url, method: .get).responseData { response in
            
            if response.result.isFailure, let error = response.result.error {
                print(error)
            }
            
            if response.result.isSuccess, let value = response.result.value {
                do {
                    let weather = try JSONDecoder().decode(WeatherModel.self, from: value)
                    
                    self.getData(data: weather)
                    self.getCurrentData()
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    private func roundCell(cell: UICollectionViewCell){
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor

    }
}



