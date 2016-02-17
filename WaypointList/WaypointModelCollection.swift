//
//  WaypointsModelCollection.swift
//  WaypointList
//
//  Created by Max Krog on 15/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import Foundation
import CoreLocation

class WaypointModelCollection: NSObject {
    
    var waypointModels = [WaypointModel]()
    
    override init(){
        super.init()
        
        if let savedWaypointModels = load() {
            print("Loaded models from memory")
            waypointModels += savedWaypointModels
        } else {
            print("Loaded model defaults")
            waypointModels += loadDefaults()
        }
        
    }
    
    func addWaypointModel(waypointModel: WaypointModel){
        self.waypointModels += [waypointModel]
    }
    
    
    //MARK: Helper
    func loadDefaults() -> [WaypointModel]{
        var retArray = [WaypointModel]()
        for index in 1..<6 {
            let indexDouble = Double(index)
            let waypoint1 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: indexDouble, longitude: indexDouble), radius: index,     title: index.description)
            let waypoint2 = Waypoint(coordinate: CLLocationCoordinate2D(latitude: indexDouble, longitude: indexDouble), radius: index, title: index.description)
            
            let waypointArray = [waypoint1, waypoint2]
            retArray += [WaypointModel(title: index.description, waypoints: waypointArray)!]
        }
        return retArray
    }
    
    //MARK: NSCoding
    func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(waypointModels, toFile: WaypointModel.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save waypoints")
        }
    }
    
    func load() -> [WaypointModel]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(WaypointModel.ArchiveURL.path!) as? [WaypointModel]
    }

}