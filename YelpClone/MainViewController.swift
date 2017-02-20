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

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business?] = []
    var filteredBusinesses: [Business?] = []
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
        createSearchBar()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return filteredBusinesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell

        let row = indexPath.row
        
        guard let businessInfo = filteredBusinesses[row] else {
            return cell
        }
        
//        if (businessInfo.rating < 4.0 && businessInfo.rating > 2){
//            let yellowColor = UIColor(red: 255/255.0, green: 223/255.0, blue: 0/255.0, alpha: 1.0)
//            cell.ratingView.backgroundColor = yellowColor
//        }else if(businessInfo.rating <= 2){
//            cell.ratingView.backgroundColor = UIColor.red
//        }


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
                self.filteredBusinesses = self.businesses
                self.tableView.reloadData()
                //self.token = json["access_token"].stringValue
            }else {
                print(response.result.error?.localizedDescription ?? "error")
            }
            
        }
        
    }
    
    func createSearchBar(){
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        self.navigationItem.titleView = searchBar
        searchBar.tintColor = UIColor.white
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.filteredBusinesses = searchText.isEmpty ? self.businesses : businesses.filter({(dataString: Business?) -> Bool in
            
            // If dataItem matches the searchText, return true to include it
            let businessTitle = dataString!.name
            return businessTitle.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        self.tableView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a variable that you want to send

        let destination = segue.destination as! MapViewController
    
        print("what \(self.businesses.count)")
        destination.businesses = self.businesses
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


