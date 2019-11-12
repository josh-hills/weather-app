//
//  ViewController.swift
//  weatherApp
//
//  Created by Josh Hills on 2018-06-06.
//  Copyright © 2018 Josh Hills. All rights reserved.
//


import Foundation

//Creates a weather structure
struct Weather {
    let summary:String //holds the summary recived from the dark sky api
    let icon:String //holds the icon
    let temperature:Double //holds the temperature
    let precipitation:Double //holds the precipitation
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        //assigns the summary that is recived from dark sky
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        //assigns the icon as a string to icon constant
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        //assigns apparent temperature to the temperature constant
        guard let temperature = json["apparentTemperatureHigh"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        //assigns the probability of precipitation to the precipitation constant
        guard let precipitation = json["precipProbability"] as? Double else {throw SerializationError.missing("precip is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.precipitation = precipitation
    }
    
    //the base path is my custion key proceeding the forecast for the dark sky api
    static let basePath = "https://api.darksky.net/forecast/4090eaac5e64c06a7c3b7cd524845725/"
    
    //function used to forecast the current weather outside
    static func forecast (withLocation location:String, completion: @escaping ([Weather]) -> ()) {
        
        //the url that we request from the api is the base link followed by the current location of the person using it
        let url = basePath + location
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                // requests the daily data from the api 
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
                
            }
            
            
        }
        
        task.resume()
        
        
        
        
        
        
        
        
        
    }
    
    
}
