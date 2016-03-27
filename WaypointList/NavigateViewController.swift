//
//  NavigateViewController.swift
//  WaypointList
//
//  Created by Max Krog on 18/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

class NavigateViewController: UIViewController, MasterTrackerDelegate, MKMapViewDelegate, MFMailComposeViewControllerDelegate {
    
    //MARK: Properties
    var masterTracker: MasterTracker!
    var waypointModel: WaypointModel!
    
    //MARK: Outlets
    @IBOutlet weak var waypointLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet var toggleLoggingButton: UIButton!
    @IBOutlet var relativeBearingLabel: UILabel!
    @IBOutlet var convertedBearingLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet weak var map: MKMapView!{
        didSet {
            map.delegate = self
            map.pitchEnabled = false
            map.rotateEnabled = false
            map.scrollEnabled = false
            map.showsUserLocation = true
            map.userTrackingMode = .FollowWithHeading
            map.mapType = .Hybrid
        }
    }
    
    //MARK: Attributes
    var logging: Bool = false

    //MARK: Actions
    @IBAction func toggleLogging(sender: UIButton) {
        if logging {
            logging = false
            toggleLoggingButton.setTitle("Resume Logging", forState: .Normal)
        } else {
            logging = true
            toggleLoggingButton.setTitle("Pause Logging", forState: .Normal)
        }
        masterTracker.toggleLogging(logging)
    }
    
    @IBAction func sendLog(sender: UIButton) {
        
        let data = masterTracker.logString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        
        let emailViewController = MFMailComposeViewController()
        emailViewController.mailComposeDelegate = self
        emailViewController.setToRecipients(["krog.max@gmail.com"])
        emailViewController.setSubject("CSV File")
        emailViewController.setMessageBody("", isHTML: false)
    
        emailViewController.addAttachmentData(data!, mimeType: "text/csv", fileName: "Sample.csv")

        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(emailViewController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
    
    //MARK: - Delegate to MasterTracker
    
    func updateActiveWaypoint(activeWaypointIndex: Int) {
        let activeWaypointIndexReadable = activeWaypointIndex + 1
        waypointLabel.text = "Active waypoint: \(activeWaypointIndexReadable.description) of \(waypointModel.waypoints.count.description)"
    }
    
    func distanceChanged() {
        distanceLabel.text = "Dist: \(masterTracker.distance)"
    }
    
    func bearingChanged(){
        relativeBearingLabel.text = "RB: \(masterTracker.relativeBearing)"
        convertedBearingLabel.text = "CB: \(masterTracker.convertedBearing)"
        
    }
    
    //MARK: - NAVIGATION
    
}
