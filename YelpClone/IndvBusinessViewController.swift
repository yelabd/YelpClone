//
//  IndvBusinessViewController.swift
//  YelpClone
//
//  Created by Youssef Elabd on 2/20/17.
//  Copyright © 2017 Youssef Elabd. All rights reserved.
//

import UIKit
import MapKit
import AFNetworking

class IndvBusinessViewController: UIViewController, CLLocationManagerDelegate {
    
    var business : Business?
    var locationManager : CLLocationManager!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let centerLocation = CLLocation(latitude: (business!.xCoordinate), longitude: business!.yCoordinate)
        goToLocation(location: centerLocation)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        
        let centerLocation2 = CLLocationCoordinate2DMake((business?.xCoordinate)!, (business?.yCoordinate)!)
        let pin = PinAnnotation(title: (business?.name)!, subtitle: " ",coordinate: centerLocation2)
        self.mapView.addAnnotation(pin)
        
        ratingView.layer.cornerRadius = 5
        posterView.layer.cornerRadius = 10
        posterView.clipsToBounds = true
        
        name.text = business?.name
        posterView.setImageWith((business?.imageURL!)!)
        reviewLabel.text = "\(business!.review) Reviews"
        addressLabel.text = "\(business!.location), \(business!.city), \(business!.state) \(business!.zip)"
        typeLabel.text = business?.type
        distanceLabel.text = String(format: "%.0f m",(business?.distance)!)
        priceLabel.text = business?.price
        ratingLabel.text = String(describing: business!.rating)
        numberLabel.text = business!.phoneNumber
        
        if (business!.rating < 4.0 && business!.rating > 2){
            let yellowColor = UIColor(red: 255/255.0, green: 223/255.0, blue: 0/255.0, alpha: 1.0)
            self.ratingView.backgroundColor = yellowColor
        }else if(business!.rating <= 2){
            self.ratingView.backgroundColor = UIColor.red
        }
        
        
//        self.ratingView.layer.borderWidth = 1

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
            let span = MKCoordinateSpanMake(0.007, 0.007)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
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
