//
//  BusinessProfile.swift
//  Scrumptious
//
//  Created by Brian Nunes De Souza on 9/23/17.
//  Copyright © 2017 scrumptious. All rights reserved.
//

import Foundation
import UIKit

var business: BusinessProfile?

class BusinessProfile{
    
    var name: String?
    var price: Double?
    var rating: Double?
    var catTitle: String?
    var id: String?
    var friendsImages: [UIImage]?
    var menu: [String]?
    
    init(name: String?, price: Double?, rating: Double?, catTitle: String?, id: String?, friendsImages: [UIImage]?, menu: [String]?){
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
}
