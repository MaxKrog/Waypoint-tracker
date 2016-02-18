//
//  ViewController.swift
//  auditory-pointers
//
//  Created by Max Krog on 12/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import UIKit
import CoreLocation

class MasterTracker:NSObject, LocationTrackerDelegate {
    

    //OWN OBJECTS
    var locationTracker: LocationTracker!
    var waypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 59.320634, longitude: 17.951006), radius: 10, title: "hej")
    
    var delegate: MasterTrackerDelegate?
    //Computed attributes
    var distance = Double(0) {
        didSet {
            print("Distance was set to: \(distance.description)")

            delegate?.updateDistance(Float(distance))
        }
    }
    var absoluteBearing = Double(0)
    var relativeBearing = Double(0) {
        didSet {
            print("Bearing was updated to: \(relativeBearing.description)")
            delegate?.updateRelativeBearing(relativeBearing)
        }
    }
    
    override init() {
        super.init()
        
        locationTracker = LocationTracker()
        locationTracker.delegate = self

    }
    
    
    //MARK: Delegate
    func locationChanged(newLocation: CLLocation) { //Calculates distance and bearing.
        let waypointLocation = CLLocation(latitude: waypoint.coordinate.latitude, longitude: waypoint.coordinate.longitude)
        distance = newLocation.distanceFromLocation(waypointLocation)
        absoluteBearing = getBearing(locationTracker.location, waypointLocation: waypointLocation)
        
    }
    
    func headingChanged(newHeading: CLLocationDirection) {
        
        func mod(a: Double, b: Double) -> Double {
            return (a - floor(a/b) * b)
        }
    
        let bearing = self.absoluteBearing
        let a = bearing - newHeading + 180
        let b = mod(a, b: 360)
        relativeBearing = b - 180

    }
    
    //MARK: Helper functions
    
    func getBearing(userLocation: CLLocation, waypointLocation: CLLocation) -> Double{
        
        func degreesToRadians(degrees: Double) -> Double { return degrees * M_PI / 180.0 }
        func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / M_PI }
        
        let lat1 = degreesToRadians(userLocation.coordinate.latitude);
        let lon1 = degreesToRadians(userLocation.coordinate.longitude);
        
        let lat2 = degreesToRadians(waypointLocation.coordinate.latitude)
        let lon2 = degreesToRadians(waypointLocation.coordinate.longitude)
        
        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        var degreesBearing = radiansToDegrees(radiansBearing)
        degreesBearing = (degreesBearing + 360) % 360; // 0 -> 360
        
        return degreesBearing
        
    }
    
    
}

protocol MasterTrackerDelegate {
    func updateDistance(newDistance: Float)
    func updateRelativeBearing( newRelativeBearing: Double)
}
