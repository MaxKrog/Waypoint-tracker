//
//  WaypointModelCollection.swift
//  WaypointList
//
//  Created by Max Krog on 15/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import Foundation

class WaypointModel: NSObject, NSCoding {
    
    //MARK: Types
    struct PropertyKey {
        static let titleKey = "title"
        static let waypointsKey = "waypoints"
    }
    
    //MARK: Properties
    var title: String
    var waypoints = [Waypoint]()
    
    init?(title: String, waypoints: [Waypoint]?){
        self.title = title
        if let waypoints = waypoints{
            self.waypoints = waypoints
        }

        super.init()
    }
    
    //MARK: NSCoding
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("WaypointsModel")
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(waypoints, forKey: PropertyKey.waypointsKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let waypoints = aDecoder.decodeObjectForKey(PropertyKey.waypointsKey) as! [Waypoint]
        self.init(title: title, waypoints: waypoints)
        
    }
    
}