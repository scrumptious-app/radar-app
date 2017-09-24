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

var businesses: BusinessProfiles?

class BusinessProfiles{
    
    var name: String?
    var price: Double?
    var rating: Double?
    var catTitle: String?
    var image: URL?
    
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
    
    func append(name: String?, price: Double?, rating: Double?, catTitle: String?, image: URL?){
        if name != nil{
            self.name = name
        }
        if rating != nil{
            self.rating = rating
        }
        if catTitle != nil{
            self.catTitle = catTitle
        }
        if price != nil{
            self.price = price
        }
        if image != nil{
            self.image = image
        }
    }
    
    func appendData(data: [String:Any]){
        
    }
}
   /*
    func updateNearby(){
        
        if businesses != nil{
        
        var request = URLRequest(url: URL(string: "https://app.bracer90.hasura-app.io/nearby?latitude=42.302851&longitude=-83.705924")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        DispatchQueue.global().async {
            let task: URLSessionDataTask = self.session.dataTask(with: request) { (data, response, error) in
                
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    // Use SwiftyJSON to parse results
                    let json1 = JSON(data: data)
                    let dataArray = json1["data"].first?.1
                    
                    for business in dataArray!{
                        businesses?.append(name: business.1["name"].string, price: business.1["price"].double , rating: business.1["rating"].double , catTitle: business.1["catTitle"].string, image: business.1["image"].url)
                        print(businesses)
                    }
                    
                    
                })
            }
        }
    }
}

*/
