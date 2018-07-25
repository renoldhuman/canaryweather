//
//  ViewController.swift
//  CanaryWeather
//
//  Created by Tyler Helmrich on 7/24/18.
//  Copyright © 2018 Tyler Helmrich. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    let forecast = Forecast();

    override func viewDidLoad() {
        forecast.startWeatherLocator();
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

