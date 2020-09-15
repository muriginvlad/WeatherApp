//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Владислав on 11.09.2020.
//  Copyright © 2020 Murygin Vladislav. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class WeatherManager {
    
    let yandexApiKeyWeather = "034add87-5cc6-44ce-adb3-77b6edcb8c4e"
    
    func loadWeathers(lat: String, lon: String, completion: @escaping (WeatherData) -> Void)  {
        
        let weather_url = "https://api.weather.yandex.ru/v2/forecast?lat=\(lat)&lon=\(lon)&extra=false&lang=ru_RU&hours=false"
        let header: HTTPHeaders = ["X-Yandex-API-Key": yandexApiKeyWeather, "Content-Type": "application/raw"]
        _ =  AF.request(weather_url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON
            { response in
                if let objects = try? response.result.get(), let jsonDict = objects as? NSDictionary
                {
                    let weathers = WeatherData(data: jsonDict )
                                    
                    DispatchQueue.main.async {
                        completion(weathers!)
                    }
                }
        }
    }
    
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            completion(placemarks?.first?.location?.coordinate, error)
        }
    }
    
    func convertLatLongToAddress(latitude:Double,longitude:Double) -> String{
        var cityName = ""
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                
                guard let placeMark = placemarks?.first else { return }
                
                if let city = placeMark.subAdministrativeArea {
                    print(city)
                    cityName = city
                }

        })
    return cityName
    }
    
}
