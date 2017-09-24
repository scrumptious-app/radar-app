//
//  BusinessProfile.swift
//  Scrumptious
//
//  Created by Brian Nunes De Souza on 9/23/17.
//  Copyright © 2017 scrumptious. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import UIKit
import SwiftyJSON

var business: BusinessProfiles?

class BusinessProfiles{
    
    var name: String?
    var price: Double?
    var rating: Double?
    var catTitle: String?
    var id: String?
    var friendsImages: [UIImage]?
    var menu: [String]?
    
    let session = URLSession.shared
    
    static var sharedInstance: HasuraAPIManager = {
        let apiManager = HasuraAPIManager()
        
        return apiManager
    }()
    
    class func shared() -> HasuraAPIManager {
        return sharedInstance
    }
    
    init(){
        
    }
    
    func append(name: String?, price: Double?, rating: Double?, catTitle: String?, id: String?, friendsImages: [UIImage]?, menu: [String]?){
        if name != nil{
            self.name = name
        }
        if rating != nil{
            self.rating = rating
        }
        if catTitle != nil{
            self.catTitle = catTitle
        }
        if id != nil{
            self.id = id
        }
        if price != nil{
            self.price = price
        }
        if friendsImages != nil{
            self.friendsImages = friendsImages
        }
        if menu != nil{
            self.menu = menu
        }
    }
    
    func appendData(data: [String:Any]){
        
    }
    
    func updateNearby(){
        var request = URLRequest(url: URL(string: "https://app.bracer90.hasura-app.io/nearby?latitude=42.302851&longitude=-83.705924")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        DispatchQueue.global().async {
            let task: URLSessionDataTask = self.session.dataTask(with: request) { (data, response, error) in
                
                print("RESPONSE FROM GETBUSINESS",response )
                print("DATA FROM GETBUSINESS", data )
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    // Use SwiftyJSON to parse results
                    let json = JSON(data: data)
                    
                    for data in json{
                        
                    }
                })
            }
        }
    }
}
