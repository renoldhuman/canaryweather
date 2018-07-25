//
//  LocationData.swift
//  CanaryWeather
//
//  Created by Tyler Helmrich on 7/24/18.
//  Copyright © 2018 Tyler Helmrich. All rights reserved.
//

import Foundation
import CoreLocation


class WeatherLocator: NSObject, CLLocationManagerDelegate{
    let locationManager = CLLocationManager();
    var location: CLLocation?;
    
    public func getLocation(){
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
//            showLocationServicesDeniedAlert()
            print("never authorized location services");
            return
        }
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.startUpdatingLocation();
    }
    
    internal func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("didFailWithError \(error)")
    }
    
    internal func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        print("didUpdateLocations" + String(describing: location))
    }
    
    public func getMostRecentLocation() -> CLLocation?{
        return location;
    }
    
}
