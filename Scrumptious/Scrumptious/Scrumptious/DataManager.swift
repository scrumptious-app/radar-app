//
//  DataManager.swift
//  Scrumptious
//
//  Created by Brian Nunes De Souza on 9/23/17.
//  Copyright © 2017 scrumptious. All rights reserved.
//

import UIKit

class DataManager {
    static var sharedInstance: DataManager = {
        let dataManager = DataManager()
        return dataManager
    }()
    
    class func shared() -> DataManager {
        return sharedInstance
    }
    
    init(){

    }

}

