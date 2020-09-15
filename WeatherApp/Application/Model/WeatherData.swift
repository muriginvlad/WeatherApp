//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Владислав on 11.09.2020.
//  Copyright © 2020 Murygin Vladislav. All rights reserved.
//

import Foundation

struct WeatherData {
    
    var currentWeather = 0
    var feels_like = 0
    var condition = ""
    var weatherCityName = ""
    var lat = 0.0
    var lon = 0.0
    var weekweather: NSArray = []
    var conditionImage = ""
    
    var cityName = ""

    
    private var dataTime : Double
    
    var data: String {
        let date = Date(timeIntervalSince1970: dataTime)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: date)
    }
    
    var time: String {
        let date = Date(timeIntervalSince1970: dataTime)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: date)
    }
    
    
    init?(data: NSDictionary) {

        guard
           
            let weekweather = data["forecasts"] as? NSArray,
            let weatherData = data["now"] as? NSNumber,
            let info = data["info"] as? NSDictionary,
            let lat = info["lat"] as? NSNumber,
            let lon = info["lon"] as? NSNumber,
            let tzinfo = info["tzinfo"] as? NSDictionary,
            let name = tzinfo["name"] as? String,
            let fact = data["fact"] as? NSDictionary,
            let currentWeather = fact["temp"] as? NSNumber,
            let feels_like = fact["feels_like"] as? NSNumber,
            let condition = fact["condition"] as? String
            else {
                return nil
        }

        self.dataTime =  weatherData.doubleValue
        self.currentWeather = currentWeather.intValue
        self.weatherCityName = name
        self.feels_like = feels_like.intValue
        self.condition = updateWeatherCondition(condition: condition)
        self.conditionImage = updateWeatherConditionImageName(condition: condition)
        self.weekweather = weekweather
        self.lat = lat.doubleValue
        self.lon = lon.doubleValue

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
    
    
    func updateWeatherConditionImageName(condition: String) -> String {
            
            switch (condition) {
            case "clear" :
                return "sunny"
            case "partly-cloudy" :
                return "mostly_cloudy"
            case "cloudy" :
                return "cloudy"
            case "overcast" :
                return "cloudy"
            case "drizzle" :
                return "rainy"
            case "light-rain" :
                return "rainy"
            case "rain" :
                return "rain"
            case "moderate-rain" :
                return "rain"
            case "heavy-rain" :
                return "heavy-rain"
            case "continuous-heavy-rain" :
                return "heavy-rain"
            case "showers" :
                return "heavy-rain"
            case "wet-snow" :
                return "mixed_rain"
            case "light-snow" :
                return "snowy"
            case "snow" :
                return "snowy"
            case "snow-showers" :
                return "heavy_snow"
            case "hail" :
                return "heavy_snow"
            case "thunderstorm" :
                return "lightning"
            case "thunderstorm-with-rain" :
                return "storm"
            case "thunderstorm-with-hail" :
                return "storm"
            default :
                return "Error"
            }
            
        }
    
}
