//
//  NavigateViewController.swift
//  WaypointList
//
//  Created by Max Krog on 18/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import UIKit

class NavigateViewController: UIViewController, MasterTrackerDelegate {
    
    //MARK: Properties
    var masterTracker: MasterTracker!
    var waypointModel: WaypointModel!
    
    //MARK: Outlets
    @IBOutlet weak var waypointLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    //MARK: Actions
    @IBAction func stepperClick(sender: UIStepper) {
        let intValue = Int(stepper.value)
        masterTracker.updateActiveWaypointIndex(intValue)
    }
    
    @IBAction func changeAuto(sender: UISwitch) {
        masterTracker.changeAuto(sender.on)
    }
    
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        print("Navigate view did load")
        super.viewDidLoad()
        
        if let waypointModel = waypointModel {
            masterTracker = MasterTracker(waypointModel: waypointModel)
            masterTracker.delegate = self
            masterTracker.play()
            navigationItem.title = waypointModel.title
            
            stepper.maximumValue = Double(waypointModel.waypoints.count - 1)
            stepper.minimumValue = 0
            stepper.value = 0
        }
        

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        masterTracker.pause()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("NavigateVew: viewWillAppear")
        super.viewWillAppear(animated)

    }
    
    //MARK: Delegate to MasterTracker
    
    func updateActiveWaypoint(activeWaypointIndex: Int) {
        let activeWaypointIndexReadable = activeWaypointIndex + 1
        waypointLabel.text = "Active waypoint: \(activeWaypointIndexReadable.description) of \(waypointModel.waypoints.count.description)"
    }
    
    //MARK: - NAVIGATION
    
}
