//
//  BusinessCell.swift
//  YelpClone
//
//  Created by Youssef Elabd on 2/18/17.
//  Copyright © 2017 Youssef Elabd. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var business : Business! {
        didSet{
            titleLabel.text = business.name
            pictureImageView.setImageWith(business.imageURL!)
            reviewLabel.text = "\(business.review) Reviews"
            addressLabel.text = business.location
            typeLabel.text = business.type
            distanceLabel.text = String(format: "%.0f m",business.distance)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureImageView.layer.cornerRadius = 3
        pictureImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
