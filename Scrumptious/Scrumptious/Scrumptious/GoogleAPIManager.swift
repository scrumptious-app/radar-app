//
//  GoogleAPIManager.swift
//  Scrumptious
//
//  Created by Brian Nunes De Souza on 9/23/17.
//  Copyright © 2017 scrumptious. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class GoogleAPIManager {
    
    var googleAPIKey = "AIzaSyApaQH7UAaP8f72yjI0xWaAnQTeq4s9JlU"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    let session = URLSession.shared
    
    static var sharedInstance: GoogleAPIManager = {
        let apiManager = GoogleAPIManager()
        
        return apiManager
    }()
    
    class func shared() -> GoogleAPIManager {
        return sharedInstance
    }
    
    func identify(image: UIImage, lat: Double, lon: Double, completionHandler:@escaping (((category: String, rating: Double, name: String, price: String, image: URL)?) -> ())) {
        // Base64 encode the image and create the request
        let binaryImagePacket = base64EncodeImage(image)
        
        createRequest(with: binaryImagePacket,lat: lat, lon: lon, completionHandler: completionHandler)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func base64EncodeImage(_ image: UIImage) -> (String, CGSize) {
        var imagedata = UIImagePNGRepresentation(image)!
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return (imagedata.base64EncodedString(options: .endLineWithCarriageReturn), image.size)
    }
    
    func createRequest(with imageBase64: (String, CGSize), lat: Double, lon: Double, completionHandler: @escaping (((category: String, rating: Double, name: String, price: String, image: URL)?) -> ())) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64.0
                ],
                "features": [
                    [
                        "type": "LOGO_DETECTION",
                        "maxResults": 3
                    ],
                    [
                        "type": "WEB_DETECTION",
                        "maxResults": 3
                    ]
                    
                ]
            ]
        ]
        
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async {
            let task: URLSessionDataTask = self.session.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                print("4----------------")
                
                DispatchQueue.main.async(execute: {
                    print("5----------------")
                    
                    // Use SwiftyJSON to parse results
                    let json = JSON(data: data)
                    let errorObj: JSON = json["error"]
                    if (errorObj.dictionaryValue != [:]) {
                        print("Error code \(errorObj["code"]): \(errorObj["message"])")
                    }
                    //                    print(json)
                    var responses: [String] = []
                    if let logoResults = json["responses"][0]["logoAnnotations"].array, logoResults.count > 0 {
                        for item in logoResults{
                            if let description = item["description"].string {
                                responses.append(description)
                            }
                            print("logo description", item)
                        }
                    }
                    
                    if let webEntities = json["responses"][0]["webDetection"]["webEntities"].array, webEntities.count > 0 {
                        for item in webEntities {
                            if let description = item["description"].string {
                                responses.append(description)
                            }
                            print("web description", item)
                        }
                    }
                    let apiManager = HasuraAPIManager.shared()
                    var calls = 0
                    // Call hasura api for each result from Google
                    responses = responses.map {
                        $0.replacingOccurrences(of: " ", with: "-")
                    }
                    print(responses)
                    var lowestResponseNum = 1000
                    var lowestResponse: (category: String, rating: Double, name: String, price: String, image: URL)? = nil
                    for response in responses {
                        let handler = {
                            (data: (category: String, rating: Double, name: String, price: String, image: URL)?) in
                            if data != nil {
                                let responseIndex = responses.index(of: response)
                                if responseIndex! <= lowestResponseNum {
                                    lowestResponseNum = responseIndex!
                                    lowestResponse = data
                                }
                                print("DispatchQueue.global() DATA", data)
                            }
                            
                            calls += 1
                            if calls == responses.count {
                                if lowestResponseNum == 1000{
                                    
                                    completionHandler(nil)
                                }else{
                                    print("FINAL RESULT")
                                    print("7----------------")
                                    
                                    completionHandler((lowestResponse!.category, lowestResponse!.rating, lowestResponse!.name, lowestResponse!.price,lowestResponse!.image))
                                    //(category: String, rating: Double, name: String, price: String, image: URL)
                                }
                            }
                        }
                        print("GOOGLE API RESPONSE: ",response)
                        if response != nil{
                        apiManager.getBusinessInfo("\(response)",lat: lat, lon: lon, completionHandler: handler)
                        }
                    }
                    
                })
            }
            
            task.resume()
        }
    }
    
    func distanceFromPointToCenterSize(p1:CGPoint, s2:CGSize) -> Double {
        let midSize = CGPoint(x: s2.width / 2, y: s2.height / 2)
        let xDist = p1.x - midSize.x
        let yDist = p1.y - midSize.y
        return Double(sqrt(xDist * xDist + yDist * yDist))
    }
}


