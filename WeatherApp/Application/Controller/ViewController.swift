//
//  ViewController.swift
//  WeatherApp
//
//  Created by Владислав on 11.09.2020.
//  Copyright © 2020 Murygin Vladislav. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    var weathers: [WeatherData] = []
    var weatherData: WeatherData? = nil
    var filteredCitys = [WeatherData]()
    private var dictionaryCitys = [
        "Москва": [55.753215, 37.622504],
        "Санкт-Петербург":[59.938951, 30.315635],
        "Токио":[35.681700, 139.753882],
        "Шанхай":[31.230863, 121.470462],
        "Нью-Йорк":[40.714599, -74.002791],
        "Париж":[48.856663, 2.351556],
        "Лондон":[51.507351, -0.127660],
        "Берлин":[52.519881, 13.407338]
    ]
    
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmty
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите город"
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        updateStockWeather()
        
    }
    
    func updateStockWeather() {
        for (key, value) in dictionaryCitys  {
            let a = String(value[0])
            let b = String(value[1])
            
            WeatherManager().loadWeathers(lat: a, lon: b) { weathers in
                var weathersData = weathers
                weathersData.cityName = key
                self.weathers.append(weathersData)
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    @IBAction func addCity(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Добавить новый город", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Добавить", style: .default) { action in
            let tf = alertController.textFields?.first
            
            if let newTaskTitle = tf?.text {
                var coordinateArray: [Double] = []
                
                
                WeatherManager().getCoordinateFrom(address: newTaskTitle) { coordinate, error in
                    guard let coordinate = coordinate, error == nil else { return }
                    coordinateArray.append(coordinate.latitude)
                    coordinateArray.append(coordinate.longitude)
                    self.dictionaryCitys["\(newTaskTitle)"] = coordinateArray
                    
                    WeatherManager().loadWeathers(lat: String(coordinate.latitude), lon: String(coordinate.longitude)) { weathers in
                        var weathersData = weathers
                        weathersData.cityName = newTaskTitle
                        self.weathers.append(weathersData)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        alertController.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Отменить", style: .default) { _ in }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCitys.count
        }
        return weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherCell
        var weathersData: WeatherData
        
        if isFiltering {
            weathersData = filteredCitys[indexPath.row]
        } else {
            weathersData =  weathers[indexPath.row]
        }
        
        cell.cityLabel.text = weathersData.cityName//weatherCityName
        cell.conditionLabel.text =  weathersData.condition
        cell.tempLabel.text =  String(weathersData.currentWeather)
        cell.conditionImage.image = UIImage(named: weathersData.conditionImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let weatherDataSelect: WeatherData
        
        if isFiltering{
            weatherDataSelect = filteredCitys[indexPath.row]
        } else {
            weatherDataSelect = weathers[indexPath.row]
        }
        weatherData = weatherDataSelect
        self.performSegue(withIdentifier: "CityWeek", sender: .none)
    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
            if self.isFiltering{
                self.filteredCitys.remove(at: indexPath.row)//[indexPath.row]
            } else {
                self.weathers.remove(at: indexPath.row)//[indexPath.row]
            }
            self.tableView.reloadData()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "CityWeek" else { return }
        guard let destination = segue.destination as? CityController else { return }
        destination.cityWeek = weatherData
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filteredContentForSearchText(_ searchText: String) {
        filteredCitys = weathers.filter({ (city:WeatherData) -> Bool in
            return city.cityName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
