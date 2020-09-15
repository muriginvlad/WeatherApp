//
//  CityController.swift
//  WeatherApp
//
//  Created by Владислав on 13.09.2020.
//  Copyright © 2020 Murygin Vladislav. All rights reserved.
//

import Foundation
import UIKit

class CityController: UIViewController {
    
    var cityWeekWeather: [NSDictionary] = []
    var cityWeek: WeatherData? = nil
    var test = ""
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = cityWeek?.cityName
        tempLabel.text = String(cityWeek!.currentWeather)
        weatherImage.image = UIImage(named: cityWeek!.conditionImage)
    }
    
    func updateWeatherCondition(condition: String) -> String {
        
        switch (condition) {
        case "clear" :
            return "ясно"
        case "partly-cloudy" :
            return "малооблачно"
        case "cloudy" :
            return "облачно с прояснениями"
        case "overcast" :
            return "пасмурно"
        case "drizzle" :
            return "морось"
        case "light-rain" :
            return "небольшой дождь"
        case "rain" :
            return "дождь"
        case "moderate-rain" :
            return "умеренно сильный дождь"
        case "heavy-rain" :
            return "сильный дождь"
        case "continuous-heavy-rain" :
            return "длительный сильный дождь"
        case "showers" :
            return "ливень"
        case "wet-snow" :
            return "дождь со снегом"
        case "light-snow" :
            return "небольшой снег"
        case "snow" :
            return "снег"
        case "snow-showers" :
            return "снегопад"
        case "hail" :
            return "град"
        case "thunderstorm" :
            return "гроза"
        case "thunderstorm-with-rain" :
            return "дождь с грозой"
        case "thunderstorm-with-hail" :
            return "гроза с градом"
        default :
            return "Error"
        }
        
    }
}

extension CityController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cityWeek!.weekweather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = cityWeek!.weekweather[indexPath.row] as! NSDictionary
        var dataTime = data["date_ts"] as! Double

        var dataFormated: String {
            let date = Date(timeIntervalSince1970: TimeInterval(dataTime))
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
            dateFormatter.locale = Locale(identifier: "ru_RU")
            return dateFormatter.string(from: date)
        }

        let parts = data["parts"] as! NSDictionary
        let day = parts["day"] as! NSDictionary
        let night = parts["night"] as! NSDictionary
        let dayshort = parts["day_short"] as! NSDictionary
       // let condition = dayshort["condition"] as! String
        
        let condition = updateWeatherCondition(condition: dayshort["condition"] as! String)
        
        let tempDay = day["temp_max"] as! Int
        let tempNight = night["temp_max"] as! Int
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CityCell
        
        cell.dayLabel.text = "\(dataFormated)"
        cell.tempNight.text = "Ночью:\(tempNight)"
        cell.tempDay.text = "Днем:\(tempDay)"
        cell.conditionLabel.text = "\(condition)"

        return cell
        }
    
}

