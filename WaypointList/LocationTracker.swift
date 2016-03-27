//
//  LocationManager.swift
//  auditory-pointers
//
//  Created by Max Krog on 12/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationTracker: NSObject, CLLocationManagerDelegate {
    
    
    //MARK: Singleton
    static let singleton = LocationTracker()
    //MARK: Properties
    var locationManager = CLLocationManager()
    var delegate: LocationTrackerDelegate?
    
    //Interesting for master.
    dynamic var location = CLLocation()
    dynamic var heading = CLLocationDirection(0) // 0 -> 360 degrees. Starting from north.
    
    //MARK: Initialization
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.headingOrientation = CLDeviceOrientation.Portrait
        locationManager.headingFilter = 1
        locationManager.startUpdatingHeading()
    }
    
    //MARK: CLLocationManagerDelegate.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        delegate?.locationChanged()
        delegate?.logPosition()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
        delegate?.updateRelativeBearing()
    }
    
}

protocol LocationTrackerDelegate {
    func locationChanged()
    func logPosition()
    func updateRelativeBearing()
}
