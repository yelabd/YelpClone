//
//  PinAnnotation.swift
//  YelpClone
//
//  Created by Youssef Elabd on 2/20/17.
//  Copyright © 2017 Youssef Elabd. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotation : NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title : String,subtitle : String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
}
