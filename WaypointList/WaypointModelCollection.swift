//
//  WaypointsModelCollection.swift
//  WaypointList
//
//  Created by Max Krog on 15/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class WaypointModelCollection: NSObject{
    
    var waypointModels = [WaypointModel]()
    static let singleton = WaypointModelCollection()
    
    var selected: Int = 0
    
    override init(){
        super.init()
        
        if let savedWaypointModels = load() {
            print("Loaded models from memory")
            waypointModels += savedWaypointModels
        }
    }
    
    func addWaypointModel(waypointModel: WaypointModel){
        self.waypointModels += [waypointModel]
    }
    
    //MARK: API
    
    func updateSelected(index: Int) {
        selected = index
    }
    
    
    //MARK: Helper
    
    //MARK: NSCoding
    func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(waypointModels, toFile: WaypointModel.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save waypoints")
        }
    }
    
    private func load() -> [WaypointModel]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(WaypointModel.ArchiveURL.path!) as? [WaypointModel]
    }

}