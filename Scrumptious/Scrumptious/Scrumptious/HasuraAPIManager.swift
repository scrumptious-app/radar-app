//
//  HasuraAPIManager.swift
//  Scrumptious
//
//  Created by Brian Nunes De Souza on 9/23/17.
//  Copyright © 2017 scrumptious. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire



class HasuraAPIManager {
    var hasuraURL: URL {
        return URL(string: "https://app.bracer90.hasura-app.io")!
    }
    let session = URLSession.shared
    
    static var sharedInstance: HasuraAPIManager = {
        let apiManager = HasuraAPIManager()
        
        return apiManager
    }()
    
    class func shared() -> HasuraAPIManager {
        return sharedInstance
    }
    
    func getBusinessInfo(_ business: String, lat: Double, lon: Double, completionHandler: @escaping (((category: String, rating: Double, name: String, price: String, image: URL)?) ->())) {
        
        // Create our request URL
        
        
        var request = URLRequest(url: URL(string: "https://app.bracer90.hasura-app.io/search?name=\(business)&latitude=\(lat)&longitude=\(lon)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Run the request on a background thread
        DispatchQueue.global().async {
            let task: URLSessionDataTask = self.session.dataTask(with: request) { (data, response, error) in
                
                print("RESPONSE FROM GETBUSINESS",response )
                print("DATA FROM GETBUSINESS", data )
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "")
                    completionHandler(nil)
                    return
                }
                
                print("WE ARE IN FUNCTION DispatchQueue.global().async ")
                
                DispatchQueue.main.async(execute: {
                     print("WE ARE IN FUNCTION DispatchQueue.global().execute ")
                    // Use SwiftyJSON to parse results
                    let json = JSON(data: data)
                    let errorObj: JSON = json["error"]
                    if (errorObj.dictionaryValue != [:]) {
                        print("Error code \(errorObj["code"]): \(errorObj["message"])")
                        completionHandler(nil)
                        return
                    }
                    
                    print("JASON VALUES", json.array)
                    var found = false
                    
                    var category: String?
                    var rating: Double?
                    var name: String?
                    var price: String?
                    var image: URL?
                    
                    //Setting possible values for BusinessProfile initialization
                    if (json["name"].exists()){
                        name = json["name"].string
                        found = true
                    }
                    if json["rating"].exists(){
                        rating = json["rating"].double
                        found = true
                    }
                    if json["category"].exists(){
                        category = json["category"].string
                        found = true
                    }
                    if json["price"].exists(){
                        price = json["price"].string
                        found = true
                    }
                    if json["name"].exists(){
                        image = json["image"].url
                        found = true
                    }
                
                    if found{
                        print("6----------------")
                        completionHandler((category,rating,name,price,image) as? (category: String, rating: Double, name: String, price: String, image: URL))
                        return
                    }else{
                        completionHandler(nil)
                        return
                    }
                })
            }
            task.resume()
        }
    }
    
    
    func getLogoForBusiness( Business: String, completionHandler: @escaping (UIImage)-> ()){
//        if let cachedImage = DataManager.shared().logoCache[Business.lowercased()]{
//            completionHandler(cachedImage)
//            return
//        }
        
        Alamofire.request(hasuraURL.appendingPathComponent("logo/\(Business)")).responseJSON { (response) in
            if let json = response.data {
                let data = JSON(data: json)
                print(data)
                if let urlStr = data["url"].string{
                    let url = URL(string: urlStr)!
                    self.downloadImage(url: url, searchTerm: Business, completionHandler: completionHandler)
                }
            }
            
        }
        
        
    }
    
    func downloadImage(url: URL, searchTerm:String, completionHandler:@escaping (UIImage)->()) {
        print("Download Started")
        print(url)
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            //            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            if let image =  UIImage(data: data){
                //DataMFanager.shared().logoCache[searchTerm.lowercased()] = image
                DispatchQueue.main.async() { () -> Void in
                    completionHandler(image)
                }
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
