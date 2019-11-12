//
//  ViewController.swift
//  weatherApp
//
//  Created by Josh Hills on 2018-06-06.
//  Copyright © 2018 Josh Hills. All rights reserved.
//

import UIKit
import CoreLocation

var myIcon:String = ""
var myPrecip:Double = 0.0 //holds percentage of chance precipitation
var myTemp:Double = 0.0 //holds the temperature outside

class ViewController: UIViewController, CLLocationManagerDelegate {
    

    @IBOutlet weak var summaryWeather: UILabel! //Label that displays the summary for the current weather
    @IBOutlet weak var umbrellaImg: UIImageView!
    @IBOutlet weak var shirtImg: UIImageView!
    @IBOutlet weak var pantsImg: UIImageView!
    var mySummary:String = "" //holds the value of the summary
    var dayOne:Bool = false //holds a bool value to see if the day is one
    
    
    
    
    //Button press of the what to wear button
    @IBAction func whatToWear(_ sender: Any) {
        print(myPrecip,myTemp,myIcon,mySummary)

        // function called to check the state of the current precipitation
        func checkPrecip() {
            
            //Checks if the temperature is above freezing and if it is likely to rain
            if myTemp >= 32 && myPrecip >= 0.4 {
                print("It will rain today, bring an umbrella.")
                mySummary = mySummary + "It will rain today, bring an umbrella. "
                umbrellaImg.image=#imageLiteral(resourceName: "umbrella.png")
                summaryWeather.text = mySummary
                
            //Checks if the temperature is freezing and if it is likely to rain
            } else if myTemp <= 32 && myPrecip >= 0.4 {
                print("It will snow today. ")
                mySummary = mySummary + "It is going to snow today. "
                summaryWeather.text = mySummary
                
            //Otherwise they will be told  to leave their umbrella at home
            } else {
                print("It most likely wont rain today, leave your umbrella at home. ")
                mySummary = mySummary + "It most likely wont rain today, leave your umbrella at home. "
                summaryWeather.text = mySummary
            }
        }
        
        //if the temperature is above 70 degrees ferinheit the user will be told to wear t-shirts and shorts, the color of the background is also changed to a red
        if myTemp >= 70.0 {
            print("It's hot, it's a good idea to wear shorts and a t-shirt.")
            mySummary = mySummary + " It's hot, it's a good idea to wear shorts and a t-shirt. "
           
            pantsImg.image = #imageLiteral(resourceName: "shorts.png")
            shirtImg.image = #imageLiteral(resourceName: "tshirt.png")
            self.view.backgroundColor = UIColor(red: 255.0/255, green: 153.0/255, blue: 51.0/255, alpha: 1)
            checkPrecip()
            
        // if the temperature is above 60 degrees ferinheit the user will be told to wear t-shirts and pants, the color of the background is also changed to a orange
        } else if myTemp >= 60.0 {
            print("Mild out, wear a tshirt and pants")
            mySummary = mySummary + " Mild out, wear a tshirt and pants. "
          
            shirtImg.image = #imageLiteral(resourceName: "tshirt.png")
            pantsImg.image = #imageLiteral(resourceName: "pants.png")
            self.view.backgroundColor = UIColor(red: 255.0/255, green: 153.0/255, blue: 103.0/255, alpha: 1)
            checkPrecip()
            
        // if the temperature is above 45 degrees ferinheit the user will be told to wear a light jacket and shorts, the color of the background is also changed to a light blue
        } else if myTemp >= 45 {
            print("It's a little chilly, wear a light jacket")
            mySummary = mySummary + " It's a little chilly, wear a light jacket. "
            pantsImg.image = #imageLiteral(resourceName: "pants.png")
            shirtImg.image = #imageLiteral(resourceName: "longsleve.png")
            self.view.backgroundColor = UIColor(red: 153/255, green: 204/255, blue: 255, alpha: 1)
            checkPrecip()
            
        // if the temperature is less than 45 degrees ferinheit the user will be told to wear winter coats and pants, the color of the background is also changed to a dark blue
        } else if myTemp <= 45 {
            print("It's freezing, wear a winter coat")
            mySummary = mySummary + " It's freezing, wear a winter coat. "
            shirtImg.image = #imageLiteral(resourceName: "wintercoat.png")
            pantsImg.image = #imageLiteral(resourceName: "pants.png")
            self.view.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 255/255, alpha: 1)
            checkPrecip()
            
        }
     }
    
        // Used to start getting the users location
        let locationManager = CLLocationManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            
            // For use when the app is open
            locationManager.requestWhenInUseAuthorization()
            
            // If location services is enabled get the users location
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        }
        
        // Print out the location to the console. Function finds current location through corelocation and sets the location into the myLocation constant
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                print(location.coordinate)
                let myLocation = location.coordinate
                
                //Preform the weather forcast function using the location recived
                Weather.forecast(withLocation: "\(myLocation.latitude),\(myLocation.longitude)") { (results:[Weather]) in
                    for result in results {
                        print("\(result)\n\n")
                        
                        //takes the temperature, precipitation, icon, summary out of the first day of the seven days it shows
                         while self.dayOne == false {
                            myTemp = result.temperature
                            myPrecip = result.precipitation
                            myIcon = result.icon
                            self.mySummary = result.summary
                            self.dayOne = true
                            
                        }
                    }
                }
            }
        
        // If we have been deined access give the user the option to change it
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if(status == CLAuthorizationStatus.denied) {
                showLocationDisabledPopUp()
            }
        }
        
        // Show the popup to the user if we have been deined access. Popup shows up asking the user for permission to have their location. If it is denied it is requested that they go into their settings to change it.
        func showLocationDisabledPopUp() {
            let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                    message: "Please enable your location, without it we cant find the weather where you are!",
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
}



