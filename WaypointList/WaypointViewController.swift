//
//  WaypointViewController.swift
//  WaypointList
//
//  Created by Max Krog on 15/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class WaypointViewController: UIViewController, MKMapViewDelegate {

    //MARK: Properties
    var waypointModel: WaypointModel?
    @IBOutlet var map: MKMapView!{
        didSet {
            map.delegate = self
            map.pitchEnabled = false
            map.rotateEnabled = false
            map.showsUserLocation = true
            let center = CLLocationCoordinate2D(latitude:59.319643, longitude:17.950818)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.05, 0.05))
            map.setRegion(region, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let waypointModel = waypointModel {
            navigationItem.title = waypointModel.title
            for(_, element) in waypointModel.waypoints.enumerate(){
                map.addAnnotation(element)
            }
            if waypointModel.waypoints.count > 0 {
                let region = MKCoordinateRegion(center: waypointModel.waypoints[0].coordinate, span: MKCoordinateSpanMake(0.02, 0.02))
                map.setRegion(region, animated: true)
            }
        }
    }
    
    //MARK: Actions
    
    @IBAction func addWaypoint(sender: UIBarButtonItem){
     let index = waypointModel?.waypoints.count.description
        let waypoint = Waypoint(coordinate: map.centerCoordinate, radius: 20, title: index)
        waypointModel?.waypoints += [waypoint]
        map.addAnnotation(waypoint)
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        //Should dequeue a view.
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        view.canShowCallout = true
        view.animatesDrop = true
        view.draggable = true
        
        return view
    }

}
