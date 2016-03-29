//
//  SettingsViewController.swift
//  WaypointList
//
//  Created by Max Krog on 19/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var audio = Audio.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func `switch`(sender: UISwitch) {
        isBeingTested = sender.on
    }
}
