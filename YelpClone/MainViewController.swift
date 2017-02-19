//
//  MainViewController.swift
//  YelpClone
//
//  Created by Youssef Elabd on 2/18/17.
//  Copyright © 2017 Youssef Elabd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business?] = []
    var token : String?
    let clientID = "brKTMeHemIXkaxGaFLVKnQ"
    let secret = "NIbKBlSyf5oFuGrjMW0ORnkG0rKAIBFnjOWkbm6Z9A0sKNQmC2g0KccVU0P3EpGs"
    let baseURL = "https://api.yelp.com/oauth2/token"
    let searchURL = "https://api.yelp.com/v3/businesses/search"
    let location = "West Lafayette, IN"

    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationController?.navigationBar.barTintColor = UIColor.red
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        getToken()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell

        let row = indexPath.row
        
        guard let businessInfo = businesses[row] else {
            return cell
        }

        cell.business = businessInfo
        
        return cell
    }
    
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
                }
                
                self.tableView.reloadData()
                //self.token = json["access_token"].stringValue
            }else {
                print(response.result.error?.localizedDescription ?? "error")
            }
            
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
