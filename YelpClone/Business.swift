//
//  Business.swift
//  YelpClone
//
//  Created by Youssef Elabd on 2/18/17.
//  Copyright © 2017 Youssef Elabd. All rights reserved.
//

import UIKit
import SwiftyJSON

class Business: NSObject {
    
    var name:String = ""
    var price:String = ""
    var location:String = ""
    var rating:Double = 0.0
    var distance:Double = 0.0
    var phoneNumber:String = ""
    var type:String = ""
    var imageURL:URL?
    var review : String = ""
    
    init(json: JSON){
        name = json["name"].stringValue
        price  = json["price"].stringValue
        location = "\(json["location"]["address1"].stringValue)"
        rating = json["rating"].doubleValue
        distance = json["distance"].doubleValue
        phoneNumber = json["phone"].stringValue
        let tempimageURL = json["image_url"].stringValue
        imageURL = URL(string: tempimageURL)
        review = json["review_count"].stringValue
        
        
        let types = json["categories"].arrayValue
        
        for thisType in types{
            if(self.type == ""){
                self.type.append(thisType["alias"].stringValue)
            }else{
                self.type.append(", \(thisType["alias"].stringValue)")
            }
            print(self.type)
        }
    }


}
