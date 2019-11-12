//
//  weatherViewController.swift
//  weatherApp
//
//  Created by Josh Hills on 2018-06-15.
//  Copyright © 2018 Josh Hills. All rights reserved.
//

import UIKit

class weatherViewController: UIViewController {
    @IBOutlet weak var iconImg: UIImageView! //Displays the image
    @IBOutlet weak var percentPrecip: UILabel! //Displays % precipitation
    @IBOutlet weak var tempLabel: UILabel! //Displays the temp
    
    //When the view loads it checks the icon and displays an image on the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        if myIcon == "partly-cloudy-night" || myIcon == "cloudy" || myIcon == "partly-cloudy-day"{
            iconImg.image = #imageLiteral(resourceName: "cloudyIcon.png")
        } else if myIcon == "wind" {
            iconImg.image = #imageLiteral(resourceName: "windIcon.png")
        } else if myIcon == "snowy" {
            iconImg.image = #imageLiteral(resourceName: "snowIcon.png")
        } else if myIcon == "sunny" {
            iconImg.image = #imageLiteral(resourceName: "sunnyIcon.png")
        } else if myIcon == "sleet" {
            iconImg.image = #imageLiteral(resourceName: "sleetIcon.png")
        }
        //Display the % precipitaion in the precipiation label
        percentPrecip.text = String(myPrecip * 100)
        //Display temperature in temp label
        tempLabel.text = String(myTemp)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
