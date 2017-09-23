//
//  MainListVC.swift
//  Scrumptious
//
//  Created by Pablo Garces on 9/23/17.
//  Copyright © 2017 scrumptious. All rights reserved.
//

import UIKit

class MainListVC: UIViewController {
    
    let toggleHistoryNotification = Notification.Name("ToggleHistoryNotification")
    let toggleHistoryActionNotification = Notification.Name("ToggleHistoryActionNotification")

    @IBOutlet weak var topTableView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let mainListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainListVC") as? MainListVC {
            let mainListVC = mainListVC
            mainListVC.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80)
            self.addChildViewController(mainListVC)
            self.view.addSubview(mainListVC.view)
            mainListVC.didMove(toParentViewController: self)
        }
        
        let path = UIBezierPath(roundedRect: topTableView.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.view.bounds
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
