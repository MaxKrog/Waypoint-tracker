//
//  WaypointTableViewCell.swift
//  WaypointList
//
//  Created by Max Krog on 15/02/16.
//  Copyright © 2016 maxkrog. All rights reserved.
//

import UIKit

class WaypointTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!

    var waypointModel: WaypointModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func updateWaypointModel(waypointModel: WaypointModel){
        nameLabel.text = waypointModel.title
        numberLabel.text = waypointModel.waypoints.count.description + " waypoints"
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
