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
    var zip: String = ""
    var city : String = ""
    var state : String = ""
    var phone: String = ""
    var imageURL:URL?
    var review : String = ""
    var xCoordinate : Double = 0.0
    var yCoordinate : Double = 0.0
    
    init(json: JSON){
        name = json["name"].stringValue
        price  = json["price"].stringValue
        location = "\(json["location"]["address1"].stringValue)"
        zip = json["location"]["zip_code"].stringValue
        state = json["location"]["state"].stringValue
        city = json["location"]["city"].stringValue
        phone = json["phone"].stringValue
        rating = json["rating"].doubleValue
        distance = json["distance"].doubleValue
        phoneNumber = json["phone"].stringValue
        let tempimageURL = json["image_url"].stringValue
        imageURL = URL(string: tempimageURL)
        review = json["review_count"].stringValue
        xCoordinate = json["coordinates"]["latitude"].doubleValue
        print(xCoordinate)
        //print("y : \(yCoordinate)")
        yCoordinate = json["coordinates"]["longitude"].doubleValue
//        print("y : \(yCoordinate)")
        
        
        let types = json["categories"].arrayValue
        
        for thisType in types{
            if(self.type == ""){
                self.type.append(thisType["alias"].stringValue)
            }else{
                self.type.append(", \(thisType["alias"].stringValue)")
            }
            //print(self.type)
        }
    }


}
