//
//  Globals.swift
//  WaypointList
//
//  Created by Max Krog on 24/03/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import Foundation
import CoreLocation

//MARK: MATH
func getRelativeBearing(heading: CLLocationDirection, absoluteBearing: CLLocationDirection ) -> Double { // -180 -> +180
        
        func mod(a: Double, b: Double) -> Double { return (a - floor(a/b) * b) }
        
        let a = heading - absoluteBearing + 180
        let b = mod(a, b: 360)
        let relativeBearing = b - 180
        
        return relativeBearing
        
    }
    
    //MARK: Helper functions
func degreesToRadians(degrees: Double) -> Double { return degrees * M_PI / 180.0 }
func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / M_PI }

func getAbsoluteBearing(userLocation: CLLocation, waypointLocation: CLLocation) -> Double { // 0 -> 360
    
    let lat1 = degreesToRadians(userLocation.coordinate.latitude);
    let lon1 = degreesToRadians(userLocation.coordinate.longitude);
    let lat2 = degreesToRadians(waypointLocation.coordinate.latitude)
    let lon2 = degreesToRadians(waypointLocation.coordinate.longitude)
    let dLon = lon2 - lon1;
    let y = sin(dLon) * cos(lat2);
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    let radiansBearing = atan2(y, x);
    var degreesBearing = radiansToDegrees(radiansBearing)
    degreesBearing = (degreesBearing + 360) % 360;
    return degreesBearing
}

func getAlpha(distance: Float, radius: Int) -> Double {
    let d = Double(distance)
    let r = Double(radius)
    let alpha = atan(r / d)
    return radiansToDegrees(alpha)
}

func convertBearing(relativeBearing: Double, alpha: Double) -> Double {
    let kvot = abs(relativeBearing) / alpha * M_PI * 0.25
    let multiplier = sin(kvot)
    let convertedBearing = relativeBearing * multiplier
    return convertedBearing
    
    
}

//MARK: Constants

struct Constants {
    var outerCaptureRadius: Int = 15
    var innerCaptureRadius: Int = 10
}