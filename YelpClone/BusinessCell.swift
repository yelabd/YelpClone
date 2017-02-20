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
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var business : Business! {
        didSet{
            titleLabel.text = business.name
            pictureImageView.setImageWith(business.imageURL!)
            reviewLabel.text = "\(business.review) Reviews"
            addressLabel.text = business.location
            typeLabel.text = business.type
            distanceLabel.text = String(format: "%.0f m",business.distance)
            priceLabel.text = business.price
            ratingLabel.text = String(business.rating)
            
            self.ratingView.layer.borderWidth = 1
//            self.ratingView.layer.borderColor =
            
//            if (business.rating < 4.0 && business.rating > 2){
//                let yellowColor = UIColor(red: 255/255.0, green: 223/255.0, blue: 0/255.0, alpha: 1.0)
//                self.ratingView.backgroundColor = yellowColor
//            }else if(business.rating <= 2){
//                self.ratingView.backgroundColor = UIColor.red
//            }
            
            print("\(business.name): \(business.rating)")

            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureImageView.layer.cornerRadius = 3
        pictureImageView.clipsToBounds = true
        ratingView.layer.cornerRadius = 10
        
       
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
