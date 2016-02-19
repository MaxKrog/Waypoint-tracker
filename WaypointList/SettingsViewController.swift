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
    

    @IBAction func sliderChanged(sender: UISlider) {
        let negValue = -1 * sender.value
        audio.updateObstruction(negValue)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
