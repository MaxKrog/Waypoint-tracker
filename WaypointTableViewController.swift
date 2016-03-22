//
//  WaypointTableViewController.swift
//  WaypointList
//
//  Created by Max Krog on 15/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import UIKit
import CoreLocation
class WaypointTableViewController: UITableViewController {

    //MARK: Props
    var waypointModelCollection = WaypointModelCollection.singleton
    
    override func viewDidLoad() {
        print("WaypointTableViewController: viewDidLoad")

        navigationItem.leftBarButtonItem = editButtonItem()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("WaypointTableViewController: viewWillAppear")
        super.viewWillAppear(animated)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waypointModelCollection.waypointModels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("WaypointTableViewCell", forIndexPath: indexPath) as! WaypointTableViewCell
        
        let waypointModel = waypointModelCollection.waypointModels[indexPath.row]
        cell.updateWaypointModel(waypointModel)

        return cell
    }

    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("UNWIND FOR SEGUE")
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }

    //MARK: Editing the rows. (Delete)
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            waypointModelCollection.waypointModels.removeAtIndex(indexPath.row)
            waypointModelCollection.save()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
     //MARK: Actions

    @IBAction func addWaypointModel(){
        var inputTextField: UITextField?
        
        let alertView = UIAlertController(title: "Add new tour", message: "Name of the new tour:", preferredStyle: .Alert)
        alertView.addTextFieldWithConfigurationHandler({
            $0.placeholder = "New name here"
            inputTextField = $0
        })
        alertView.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alertView.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler:{ (action) -> Void in
            
            let newIndexPath = NSIndexPath(forRow: self.waypointModelCollection.waypointModels.count, inSection: 0)
            
            let waypointModel = WaypointModel(title: inputTextField!.text!, waypoints: nil)!
            self.waypointModelCollection.addWaypointModel(waypointModel)
            
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .None)
            self.tableView.selectRowAtIndexPath(newIndexPath, animated: false, scrollPosition: .None)
            let tableCell = self.tableView.cellForRowAtIndexPath(newIndexPath)
            
            self.performSegueWithIdentifier("ShowWaypoints", sender: tableCell)
            
        }))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToTableView(sender: UIStoryboardSegue) {
        if sender.sourceViewController is AddWaypointViewController{
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            waypointModelCollection.save()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowWaypoints" {
            
            let waypointViewController = segue.destinationViewController as! AddWaypointViewController
            
            if let selectedWaypointTableViewCell = sender as? WaypointTableViewCell {
                //Executed by click of a table-cell
                let indexPath = tableView.indexPathForCell(selectedWaypointTableViewCell)
                let selectedWaypointModel = waypointModelCollection.waypointModels[indexPath!.row]
                waypointViewController.waypointModel = selectedWaypointModel
            }
        } else if segue.identifier == "StartTour" {
            print("Preparing for segue start tour")
            
            if let dwc = segue.destinationViewController as? NavigateViewController {
                if let button = sender as? UIButton {
                    if let selectedTableViewCell = button.superview?.superview as? WaypointTableViewCell {
                        let indexPath = tableView.indexPathForCell(selectedTableViewCell)
                        let selectedWaypointModel = waypointModelCollection.waypointModels[indexPath!.row]
                        
                        dwc.waypointModel = selectedWaypointModel
                    }
                }
            }
        }
    }
}