//
//  ViewController.swift
//  auditory-pointers
//
//  Created by Max Krog on 12/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import UIKit
import CoreLocation

class MasterTracker: NSObject, LocationTrackerDelegate {
    

    //OWN OBJECTS
    var audio = Audio.singleton
    var locationTracker = LocationTracker.singleton
    
    var waypointModel: WaypointModel!
    var activeWaypointIndex: Int = 0
    var changeWaypointWhenClose = false
    
    var delegate: MasterTrackerDelegate?
    
    //Computed attributes
    var absoluteBearing = Double(0)

    init(waypointModel : WaypointModel) {
        super.init()
        self.locationTracker.delegate = self
        self.waypointModel = waypointModel
    }
    
    //MARK: Public API
    
    func updateActiveWaypointIndex(newIndex: Int){
        activeWaypointIndex = newIndex
        delegate?.updateActiveWaypoint(activeWaypointIndex)
        locationChanged()
    }
    
    func changeAuto(newAuto: Bool) {
        changeWaypointWhenClose = newAuto
    }
    
    func play(){
        audio.play()
    }
    
    func pause(){
        audio.pause()
    }
    
    
    //MARK: Delegate for LocationTracker
    func locationChanged() { //Calculates distance and bearing.
        let newLocation = locationTracker.location
        delegate?.updateActiveWaypoint(activeWaypointIndex)

        let activeWaypoint = waypointModel.waypoints[activeWaypointIndex]
        let activeWaypointLocation = CLLocation(latitude: activeWaypoint.coordinate.latitude, longitude: activeWaypoint.coordinate.longitude)
        
        let distance = Float(newLocation.distanceFromLocation(activeWaypointLocation))
        audio.updateDistance(distance)
        absoluteBearing = getBearing(locationTracker.location, waypointLocation: activeWaypointLocation)
        
        if distance < 10 && changeWaypointWhenClose {
            let newIndex = activeWaypointIndex + 1
            if newIndex < waypointModel.waypoints.count {
                activeWaypointIndex = newIndex
                audio.yaay()
                
                
            }
        }
    }
    
    func headingChanged() {
        let newHeading = locationTracker.heading
        
        func mod(a: Double, b: Double) -> Double {
            return (a - floor(a/b) * b)
        }
        
        let absoluteBearing = self.absoluteBearing
        let a = absoluteBearing - newHeading + 180
        let b = mod(a, b: 360)
        let relativeBearing = b - 180
        audio.updateRelativeBearing(relativeBearing)

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
    func updateActiveWaypoint(activeWaypointIndex: Int)
}
