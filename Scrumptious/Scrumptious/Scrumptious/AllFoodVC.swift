//
//  AllFoodVC.swift
//  Scrumptious
//
//  Created by Pablo Garces on 9/23/17.
//  Copyright © 2017 scrumptious. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class AllFoodVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.delegate = self
        foodTableView.dataSource = self
        
        let gestureDown = UISwipeGestureRecognizer(target: self, action: #selector(gestureSegue))
        gestureDown.direction = .down
        topView.addGestureRecognizer(gestureDown)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //topView.roundCorners(corners: [.topLeft , .topRight], radius: 16)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        topView.roundCorners(corners: [.topLeft , .topRight], radius: 16)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        
        
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: StoreCell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath as IndexPath) as! StoreCell
        
        if indexPath.row == 0{
            let tempUrl = URL(fileURLWithPath: "https://s3-media3.fl.yelpcdn.com/bphoto/y8Cs_r3JXr0T14zaPMiE6A/o.jpg")
            
            cell.storeImg.sd_setImage(with: tempUrl, placeholderImage: UIImage(named: "noimg"))
            cell.storeTitle.text = "Starbucks"
            
            cell.star1.image = UIImage(named: "starYellow")
            cell.star2.image = UIImage(named: "starYellow")
            cell.star3.image = UIImage(named: "starYellow")
            cell.star4.image = UIImage(named: "starGrey")
            cell.star5.image = UIImage(named: "starGrey")
            
            cell.storeReview.text = "Starbucks Corporation is an American coffee company and coffeehouse chain."
            
            cell.storeDistance.text = "$$"
        }
        else if indexPath.row == 1{
            
            let tempUrl = URL(fileURLWithPath: "https://s3-media3.fl.yelpcdn.com/bphoto/y8Cs_r3JXr0T14zaPMiE6A/o.jpg")
            
            cell.storeImg.sd_setImage(with: tempUrl, placeholderImage: UIImage(named: "noimg"))
            cell.storeTitle.text = "Ann Arbor Bed and Breakfast"
            
            cell.star1.image = UIImage(named: "starYellow")
            cell.star2.image = UIImage(named: "starYellow")
            cell.star3.image = UIImage(named: "starYellow")
            cell.star4.image = UIImage(named: "starYellow")
            cell.star5.image = UIImage(named: "starGrey")
            //Ann Arbor lodging B&B inn, boutique hotel on campus downtown with king beds, hot breakfast, free on-site parking, WiFi, en suite bathrooms
            cell.storeReview.text = "Ann Arbor lodging B&B inn, boutique hotel on campus downtown with king beds, hot breakfast, free on-site parking, WiFi, en suite bathrooms."
            
            cell.storeDistance.text = "$$"
        }
        else if indexPath.row == 2{
            let tempUrl = URL(fileURLWithPath: "https://s3-media3.fl.yelpcdn.com/bphoto/y8Cs_r3JXr0T14zaPMiE6A/o.jpg")
            
            cell.storeImg.sd_setImage(with: tempUrl, placeholderImage: UIImage(named: "noimg"))
            cell.storeTitle.text = "Orangetheory Fitness"
            
            cell.star1.image = UIImage(named: "starYellow")
            cell.star2.image = UIImage(named: "starYellow")
            cell.star3.image = UIImage(named: "starYellow")
            cell.star4.image = UIImage(named: "starYellow")
            cell.star5.image = UIImage(named: "starYellow")
            
            cell.storeReview.text = "The physiological theory behind Orangetheory is known as excess post-exercise oxygen consumption."
            
            cell.storeDistance.text = ""
        }
        else if indexPath.row == 3{
            let tempUrl = URL(fileURLWithPath: "https://s3-media3.fl.yelpcdn.com/bphoto/y8Cs_r3JXr0T14zaPMiE6A/o.jpg")
            
            cell.storeImg.sd_setImage(with: tempUrl, placeholderImage: UIImage(named: "noimg"))
            cell.storeTitle.text = "Ita Yoga Studio"
            
            cell.star1.image = UIImage(named: "starYellow")
            cell.star2.image = UIImage(named: "starYellow")
            cell.star3.image = UIImage(named: "starYellow")
            cell.star4.image = UIImage(named: "starYellow")
            cell.star5.image = UIImage(named: "starGrey")
            
            cell.storeReview.text = "Vinyasa flow style yoga in an Infrared Heated spacious studio. From Gentle and Yin practice to Guided Vinyasa and Power Flow"
            
            cell.storeDistance.text = ""
        }
        else if indexPath.row == 4{
            let tempUrl = URL(fileURLWithPath: "https://s3-media3.fl.yelpcdn.com/bphoto/y8Cs_r3JXr0T14zaPMiE6A/o.jpg")
            
            cell.storeImg.sd_setImage(with: tempUrl, placeholderImage: UIImage(named: "noimg"))
            cell.storeTitle.text = "The Songbird Cafe"
            
            
            cell.star1.image = UIImage(named: "starYellow")
            cell.star2.image = UIImage(named: "starYellow")
            cell.star3.image = UIImage(named: "starYellow")
            cell.star4.image = UIImage(named: "starYellow")
            cell.star5.image = UIImage(named: "starGrey")
            
            cell.storeReview.text = "Creative American eatery serving espresso drinks, soups, sandwiches & baked goods in a cozy setting."
            
            cell.storeDistance.text = "$$"
        }
        else if indexPath.row == 5{
            let tempUrl = URL(fileURLWithPath: "https://s3-media3.fl.yelpcdn.com/bphoto/y8Cs_r3JXr0T14zaPMiE6A/o.jpg")
            
            cell.storeImg.sd_setImage(with: tempUrl, placeholderImage: UIImage(named: "noimg"))
            cell.storeTitle.text = "Evergreen Restaurant"
            
            cell.star1.image = UIImage(named: "starYellow")
            cell.star2.image = UIImage(named: "starYellow")
            cell.star3.image = UIImage(named: "starYellow")
            cell.star4.image = UIImage(named: "starGrey")
            cell.star5.image = UIImage(named: "starGrey")
            
            cell.storeReview.text = "Spacious Chinese standby lures locals with its regional dishes, lunch deals & laid-back atmosphere."
            
            cell.storeDistance.text = "$$"
        }
        else if indexPath.row == 6{
            let tempUrl = URL(fileURLWithPath: "https://s3-media3.fl.yelpcdn.com/bphoto/y8Cs_r3JXr0T14zaPMiE6A/o.jpg")
            
            cell.storeImg.sd_setImage(with: tempUrl, placeholderImage: UIImage(named: "noimg"))
            cell.storeTitle.text = "The Petting Farm at Domino's Farms"
            
            cell.star1.image = UIImage(named: "starYellow")
            cell.star2.image = UIImage(named: "starYellow")
            cell.star3.image = UIImage(named: "starYellow")
            cell.star4.image = UIImage(named: "starYellow")
            cell.star5.image = UIImage(named: "starGrey")
            
            cell.storeReview.text = "A wonderful, serene place to bring family and friends for a memorable day! "
            
            cell.storeDistance.text = "$$"
        }
        else if indexPath.row == 7{
            let tempUrl = URL(fileURLWithPath: "https://s3-media3.fl.yelpcdn.com/bphoto/y8Cs_r3JXr0T14zaPMiE6A/o.jpg")
            
            cell.storeImg.sd_setImage(with: tempUrl, placeholderImage: UIImage(named: "noimg"))
            cell.storeTitle.text = "Pure Visibility"
            
            cell.star1.image = UIImage(named: "starYellow")
            cell.star2.image = UIImage(named: "starYellow")
            cell.star3.image = UIImage(named: "starYellow")
            cell.star4.image = UIImage(named: "starYellow")
            cell.star5.image = UIImage(named: "starGrey")
            
            cell.storeReview.text = "Are you looking to maximize ROI from your digital marketing campaigns? Pure Visibility provides expert SEO, PPC, social media and analytics services."
            
            cell.storeDistance.text = ""
        }
        else if indexPath.row == 8{
            let tempUrl = URL(fileURLWithPath: "https://s3-media3.fl.yelpcdn.com/bphoto/y8Cs_r3JXr0T14zaPMiE6A/o.jpg")
            
            cell.storeImg.sd_setImage(with: tempUrl, placeholderImage: UIImage(named: "noimg"))
            cell.storeTitle.text = "Subway"
            
            cell.star1.image = UIImage(named: "starYellow")
            cell.star2.image = UIImage(named: "starYellow")
            cell.star3.image = UIImage(named: "starGrey")
            cell.star4.image = UIImage(named: "starGrey")
            cell.star5.image = UIImage(named: "starGrey")
            
            cell.storeReview.text = "Subway IP Inc. is a privately held American fast food restaurant franchise that primarily sells submarine sandwiches and salads."
            
            cell.storeDistance.text = "$"
        }
        else if indexPath.row == 9{
            let tempUrl = URL(fileURLWithPath: "https://s3-media3.fl.yelpcdn.com/bphoto/y8Cs_r3JXr0T14zaPMiE6A/o.jpg")
            
            cell.storeImg.sd_setImage(with: tempUrl, placeholderImage: UIImage(named: "noimg"))
            cell.storeTitle.text = "Leslie Park Golf Course"
            
            cell.star1.image = UIImage(named: "starYellow")
            cell.star2.image = UIImage(named: "starYellow")
            cell.star3.image = UIImage(named: "starYellow")
            cell.star4.image = UIImage(named: "starYellow")
            cell.star5.image = UIImage(named: "starGrey")
            
            cell.storeReview.text = "The award-winning Leslie Park Golf Course is a beautiful par 72, 18-hole, 6,611-yard golf championship course set on the rolling hills of northeast Ann Arbor."
            
            cell.storeDistance.text = ""
        }
        
        return cell
    }
    
    @IBAction func downBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func gestureSegue() {
        self.dismiss(animated: true, completion: nil)
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

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
