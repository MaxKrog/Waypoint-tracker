//
//  WaypointModel.swift
//  WaypointList
//
//  Created by Max Krog on 15/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Waypoint: NSObject, MKAnnotation, NSCoding {
    
    //MARK: Types
    struct PropertyKey {
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
        static let radiusKey = "radius"
        static let titleKey = "title"
    }
    
    //MARK: Properties
    var title: String?
    var radius: Int
    var coordinate: CLLocationCoordinate2D
    
    //MARK: Initializer
    
    init(coordinate: CLLocationCoordinate2D, radius: Int, title: String?){
        self.coordinate = coordinate
        self.radius = radius
        self.title = title
        
        super.init()
    }
    
    
    //MARK: NSCoding
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("waypoints")

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(coordinate.latitude, forKey: PropertyKey.latitudeKey)
        aCoder.encodeObject(coordinate.longitude, forKey: PropertyKey.longitudeKey)
        aCoder.encodeObject(radius, forKey: PropertyKey.radiusKey)
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)

    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let latitude = aDecoder.decodeObjectForKey(PropertyKey.latitudeKey) as! CLLocationDegrees
        let longitude = aDecoder.decodeObjectForKey(PropertyKey.longitudeKey) as! CLLocationDegrees
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let radius = aDecoder.decodeObjectForKey(PropertyKey.radiusKey) as! Int
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        self.init(coordinate: coordinate, radius: radius, title: title)
        
    }
    
    
}