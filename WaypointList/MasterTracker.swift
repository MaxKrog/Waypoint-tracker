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
    
    //MARK: Computed attributes
    var absoluteBearing = Double(0)
    var alpha = Double(0) {
        didSet {
            print(alpha)
        }
    }
    var relativeBearing = Double(0) {
        didSet {
            if abs(relativeBearing) < alpha && distance < Float(Constants().calculateAlphaDistance) {
                self.convertedBearing = convertBearing(relativeBearing, alpha: self.alpha)
            } else {
                audio.updateRelativeBearing(relativeBearing)
            }
            if abs(relativeBearing) > 90 {
                //audio.EQNode.bypass = false
                audio.player.obstruction = -10
            } else {
                //audio.EQNode.bypass = true
                audio.player.obstruction = 0
            }
            delegate?.bearingChanged()
            
        }
    }
    var convertedBearing = Double(0) {
        didSet {
            audio.updateRelativeBearing(convertedBearing)
        }
    }
    var distance = Float(0) {
        didSet {
            delegate?.distanceChanged()
            audio.updateDistance(distance)
        }
    }

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
    
    var logging: Bool = false
    var logString = NSMutableString(string: "Lat,Lng,Heading,Accuracy,WaypointIndex\n")
    func toggleLogging(state: Bool){
        self.logging = state
        print(state.description)
    }
    
    
    //MARK: Delegate for LocationTracker
    func locationChanged() { //Calculates distance and bearing.
        let newLocation = locationTracker.location

        let activeWaypoint = waypointModel.waypoints[activeWaypointIndex]
        let activeWaypointLocation = CLLocation(latitude: activeWaypoint.coordinate.latitude, longitude: activeWaypoint.coordinate.longitude)
        

        
        self.distance = Float(newLocation.distanceFromLocation(activeWaypointLocation))
        self.alpha = getAlpha(self.distance, radius: activeWaypoint.radius)
        self.absoluteBearing = getAbsoluteBearing(locationTracker.location, waypointLocation: activeWaypointLocation)
        self.updateRelativeBearing()
        
        if distance < Float(Constants().outerCaptureRadius) && changeWaypointWhenClose {
            let newIndex = activeWaypointIndex + 1
            if newIndex < waypointModel.waypoints.count {
                audio.yaay()
                updateActiveWaypointIndex(newIndex)
            }
        }
        

    }
    
    func updateRelativeBearing() {
        self.relativeBearing = getRelativeBearing(locationTracker.heading, absoluteBearing: self.absoluteBearing)

    }
    
    func logPosition(){
        if logging {
            let lat = locationTracker.location.coordinate.latitude.description
            let lng = locationTracker.location.coordinate.longitude.description
            let heading = locationTracker.heading.description
            let accuracy = locationTracker.location.horizontalAccuracy.description
            let index = activeWaypointIndex.description
            
            self.logString.appendString("\(lat),\(lng),\(heading),\(accuracy),\(index)\n")
        }
    }
}

//MARK: MasterTrackerDelegate
protocol MasterTrackerDelegate {
    func updateActiveWaypoint(activeWaypointIndex: Int)
    func distanceChanged()
    func bearingChanged()
}

