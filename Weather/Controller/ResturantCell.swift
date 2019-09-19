//
//  ResturantCell.swift
//  Weather
//
//  Created by Rasel Miah on 19/9/19.
//  Copyright © 2019 Winas Inc. All rights reserved.
//

import UIKit

class ResturantCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
