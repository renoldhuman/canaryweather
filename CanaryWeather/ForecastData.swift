//
//  ForecastData.swift
//  CanaryWeather
//
//  Created by Tyler Helmrich on 7/24/18.
//  Copyright © 2018 Tyler Helmrich. All rights reserved.
//

import Foundation
import CoreLocation


public class DailyWeather: Codable{
    var icon = "";
    var time = 0;
    var precipProbability = 0.0;
    var temperatureHigh = 0.0;
    var temperatureLow = 0.0;
    var humidity = 0.0;
    var pressure = 0.0;
    var windSpeed = 0.0;
    var cloudCover = 0.0;
    var uvIndex = 0;
}

private class WeatherData: Codable{
    var data = [DailyWeather]();
}

private class WeatherResults: Codable{
    var daily = WeatherData();
}

class Forecast{
    
    private let forecastDateFormatter: DateFormatter = DateFormatter();
    private let forecastStringKey: String = "https://api.darksky.net/forecast/" + APIKEY.DARKSKYKEY + "/";
    private let exclusions: String = "exclude=currently,minutely,hourly,flags,alerts"
    private let placeHolderLatLong: String = "40.7484,-73.9857";
    private let weatherLocator: WeatherLocator = WeatherLocator();
    
    
    
    init() {
        forecastDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    }

    
    //requestData: Makes a request to the specified URL
    //Make the request
    //If there's an error, handle the error
    //Returns a Data object
    private func requestData(url: URL) -> Data?{
        do {
            return try Data(contentsOf: url);
        } catch {
            print("Download Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func getWeatherData(url: URL) -> [DailyWeather]{
        let requestedData: Data = self.requestData(url: url)!;
        return parseForecast(forecastData: requestedData);
    }
    
    //Makes the request to the server asynchronously
    private func asyncRequestData(url: URL) -> [DailyWeather]{
        let queue = DispatchQueue.global();
        
        var weatherData: [DailyWeather] = [];
        
        queue.async {
            let requestedData: Data = self.requestData(url: url)!;
            weatherData = self.parseForecast(forecastData: requestedData);
        }
        
        return weatherData;
    }
    
    
    //parseForecast: parse the JSON response into the WeatherResults class
    //create a JSON decoder
    //store results of decode into weather results
    //return the array of DailyWeather
    private func parseForecast(forecastData: Data) -> [DailyWeather]{
        do {
            let decoder = JSONDecoder();
            let weatherResult = try decoder.decode(WeatherResults.self, from:forecastData);
            return weatherResult.daily.data;
        } catch {
            print("JSON Error: \(error)");
            return [];
        }
    }
    
    //getForecastForDay: gets the Forecast for days Nine and Ten not provided by dark sky
    //Using the provided API Key and specified starting time interval from 1970 epoch
    //Get seconds for 8 and 9 days
    //Add those seconds to the given time interval
    //Create url strings
    //Construct a URL Object
    //Make a request using asynchrequestdata
    private func getForecastForRemainingDays(startingTimeInterval: TimeInterval) -> [DailyWeather]{
        var daysNineAndTenWeather: [DailyWeather] = [];
        
        let dayInSeconds: Int = 86400;
        let dayNineInSeconds: String = String(Int(Double(dayInSeconds * 8) + startingTimeInterval));
        let dayTenInSeconds: String = String(Int(Double(dayInSeconds * 9) + startingTimeInterval));
        
        let dayNineUrlString: String = forecastStringKey + placeHolderLatLong + "," + dayNineInSeconds + "?" + exclusions;
        let encodedDayNine: String = dayNineUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!;
        let dayNineUrl: URL = URL(string: encodedDayNine)!;
        
        let dayTenUrlString: String = forecastStringKey + placeHolderLatLong + "," + dayTenInSeconds + "?" + exclusions;
        let encodedDayTen: String = dayTenUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!;
        let dayTenUrl: URL = URL(string: encodedDayTen)!;
        
        let dayNineWeather: [DailyWeather] = getWeatherData(url: dayNineUrl);
        let dayTenWeather: [DailyWeather] = getWeatherData(url: dayTenUrl);
        
        daysNineAndTenWeather.append(contentsOf: dayNineWeather);
        daysNineAndTenWeather.append(contentsOf: dayTenWeather);
        
        return daysNineAndTenWeather;
    }
    
    //getForecastForWeeK: gets the forecast for the next week
    //Using the API key and exclusions
    //Construct a URL Object
    //Make a request using request Data
    private func getForecastForWeek() -> [DailyWeather]{
        let forecastUrlString: String = forecastStringKey + placeHolderLatLong + "?" + exclusions;
        let encodedForecast: String = forecastUrlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!;
        
        let forecastUrl: URL = URL(string: encodedForecast)!;
        
        return getWeatherData(url: forecastUrl);
    }
    
    public func getTenDayForecast() -> [DailyWeather]{
        var forecastWeather: [DailyWeather] = [];
        
        let queue = DispatchQueue.global();
        
        queue.async {
            let weekWeather: [DailyWeather] = self.getForecastForWeek();
            
            let startingDay: TimeInterval = TimeInterval(weekWeather[0].time);
            
            let nineTenWeather: [DailyWeather] = self.getForecastForRemainingDays(startingTimeInterval: startingDay);
            
            forecastWeather.append(contentsOf: weekWeather);
            forecastWeather.append(contentsOf: nineTenWeather);
            
            for weather in forecastWeather{
                print(weather.temperatureHigh);
            }
        }
        

        
        return forecastWeather;
    }
    
    public func startWeatherLocator(){
        weatherLocator.getLocation();
        weatherLocator.getMostRecentLocation();
    }
    
}
