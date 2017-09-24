//
//  StoreCell.swift
//  Scrumptious
//
//  Created by Pablo Garces on 9/23/17.
//  Copyright © 2017 scrumptious. All rights reserved.
//

import UIKit

class StoreCell: UITableViewCell {

    @IBOutlet weak var storeImg: UIImageView!
    @IBOutlet weak var storeTitle: UILabel!
    @IBOutlet weak var storeDistance: UILabel!
    @IBOutlet weak var storeReview: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        storeImg.layer.masksToBounds = true
        storeImg.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
