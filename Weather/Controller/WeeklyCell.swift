//
//  WeeklyCell.swift
//  Weather
//
//  Created by Rasel Miah on 18/9/19.
//  Copyright © 2019 Winas Inc. All rights reserved.
//

import UIKit

class WeeklyCell: UITableViewCell {

    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
