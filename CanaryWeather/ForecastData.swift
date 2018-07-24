//
//  ForecastData.swift
//  CanaryWeather
//
//  Created by Tyler Helmrich on 7/24/18.
//  Copyright © 2018 Tyler Helmrich. All rights reserved.
//

import Foundation


class Forecast{
    
    private let forecastDateFormatter: DateFormatter = DateFormatter();
    private let forecastStringKey: String = "https://api.darksky.net/forecast/" + APIKEY.DARKSKYKEY + "/";
    private let exclusions: String = "exclude=currently,minutely,hourly,flags,alerts"
    private let placeHolderLatLong: String = "40.7484,-73.9857";
    
    
    
    init() {
        forecastDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    }

    
    //requestData: Makes a request to the specified URL
    //Make the request
    //If there's an error, handle the error
    //Returns a Data object
    private func requestData(url: URL) -> String?{
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    //getForecastForDay: gets the Forecast for the days past the 1 week limit up to 3 days
    //Using the provided API Key and specified Date
    //Construct a URL Object
    //Make a request using requestData
//    private func getForecastForDay(day: Date){
//        let currentDate: String = forecastDateFormatter.string(from: day);
//        let forecastUrlString = fo
//    }
    
    //getForecastForWeeK: gets the forecast for the next week
    //Using the API key and exclusions
    //Construct a URL Object
    //Make a request using request Data
    public func getForecastForWeek(){
        let forecastUrlString: String = forecastStringKey + placeHolderLatLong + "?" + exclusions;
        let encodedForecast: String = forecastUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!;
        
        let forecastUrl: URL = URL(string: encodedForecast)!;
        
        let requestedData: String = requestData(url: forecastUrl)!;
        
        print(requestedData);
    }
}
