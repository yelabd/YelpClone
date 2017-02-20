//
//  MapViewController.swift
//  YelpClone
//
//  Created by Youssef Elabd on 2/19/17.
//  Copyright © 2017 Youssef Elabd. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, CLLocationManagerDelegate  {
    
    var locationManager : CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var businesses: [Business?] = []
    
    let clientID = "brKTMeHemIXkaxGaFLVKnQ"
    let secret = "NIbKBlSyf5oFuGrjMW0ORnkG0rKAIBFnjOWkbm6Z9A0sKNQmC2g0KccVU0P3EpGs"
    let baseURL = "https://api.yelp.com/oauth2/token"
    let searchURL = "https://api.yelp.com/v3/businesses/search"
    let location = "West Lafayette, IN"
    var token : String?
    
    func getToken(){
        Alamofire.request(baseURL,method: .post,parameters: ["grant_type" : "client_credentials","client_id" : clientID,"client_secret" : secret],encoding: URLEncoding.default,headers : nil).responseJSON{ response in
            
            if response.result.isSuccess {
                guard let info = response.result.value else {
                    print("Error")
                    return
                }
                print(info)
                let json = JSON(info)
                print(json)
                
                self.token = json["access_token"].stringValue
                self.loadBusiness()
            }
            
        }
    }
    
    func loadBusiness(){
        Alamofire.request(searchURL,method : .get, parameters: ["location" : location],encoding: URLEncoding.default,headers: ["Authorization" : "Bearer \(token!)"]).validate().responseJSON{response in
            
            if response.result.isSuccess {
                guard let info = response.result.value else {
                    print("Error")
                    return
                }
                //print(info)
                let json = JSON(info)
                //print(json)
                
                let businesses = json["businesses"].arrayValue
                
                for business in businesses{
                    let businessInfo = Business(json: business)
                    self.businesses.append(businessInfo)
                     print(businessInfo.xCoordinate)
                }
                 print("HHHHHHHHHH \(businesses.count)")
                
                for business in self.businesses{
//                    let centerLocation = CLLocationCoordinate2D(latitude: (business?.xCoordinate)!, longitude: (business?.yCoordinate)!)
//                    self.addAnnotationAtCoordinate(coordinate: centerLocation, info: (business?.name)!)
                    let centerLocation = CLLocationCoordinate2DMake((business?.xCoordinate)!, (business?.yCoordinate)!)
                    //            addAnnotationAtCoordinate(coordinate: centerLocation, info: (business?.name)!)
                    let pin = PinAnnotation(title: (business?.name)!, subtitle: (business?.type)!,coordinate: centerLocation)
                    self.mapView.addAnnotation(pin)
                    
                }
//
//                 self.mapView.reloadInputViews()
//                               self.addAnnotations()
//                self.filteredBusinesses = self.businesses
//                self.tableView.reloadData()
                //self.token = json["access_token"].stringValue
            }else {
                print(response.result.error?.localizedDescription ?? "error")
            }
            
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let centerLocation = CLLocation(latitude: 40.42586, longitude: -86.908066)
        goToLocation(location: centerLocation)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        getToken()
        
        print("HHHHHHHHHH \(businesses.count)")
        for business in self.businesses{
            //                    let centerLocation = CLLocationCoordinate2D(latitude: (business?.xCoordinate)!, longitude: (business?.yCoordinate)!)
            //                    self.addAnnotationAtCoordinate(coordinate: centerLocation, info: (business?.name)!)
            let centerLocation = CLLocationCoordinate2DMake((business?.xCoordinate)!, (business?.yCoordinate)!)
            print(business?.xCoordinate)
            //            addAnnotationAtCoordinate(coordinate: centerLocation, info: (business?.name)!)
            let pin = PinAnnotation(title: (business?.name)!, subtitle: " ",coordinate: centerLocation)
            self.mapView.addAnnotation(pin)
            
        }

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D,info : String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = info
        mapView.addAnnotation(annotation)
    }
    
    func addAnnotations(){
        
        print("Heeeeereeeeeee\(businesses.count)")

        for business in businesses{
            let centerLocation = CLLocationCoordinate2DMake((business?.xCoordinate)!, (business?.yCoordinate)!)
//            addAnnotationAtCoordinate(coordinate: centerLocation, info: (business?.name)!)
            let pin = PinAnnotation(title: (business?.name)!, subtitle: " ",coordinate: centerLocation)
            mapView.addAnnotation(pin)
            
        }
        
        mapView.reloadInputViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
