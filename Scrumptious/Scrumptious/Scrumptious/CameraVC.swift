//
//  CameraVC.swift
//  Scrumptious
//
//  Created by Pablo Garces on 9/23/17.
//  Copyright © 2017 scrumptious. All rights reserved.
//

import UIKit

class CameraVC: UIViewController, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    let nearbyTableView = UITableView()
    let nearbyScroller = UIScrollView()
    let nearbyInnerScrollView = UIView()
    let topTableView = UIView()
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nearbyScroller.delegate = self
        nearbyTableView.delegate = self
        
        let path = UIBezierPath(roundedRect: topTableView.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        
        topTableView.addGestureRecognizer(gesture)
        topTableView.isUserInteractionEnabled = true
        gesture.delegate = self
        
        maskLayer.frame = self.view.bounds
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Setup top table view
        topTableView.frame = CGRect(x: 0.0, y: view.frame.size.height + 100.0, width: view.frame.size.width, height: 100.0)
        topTableView.backgroundColor = UIColor.yellow
        view.addSubview(topTableView)
    }

    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began || gestureRecognizer.state == UIGestureRecognizerState.changed {
            let translation = gestureRecognizer.translation(in: self.view)
            print(gestureRecognizer.view!.center.y)
            if (gestureRecognizer.view!.center.y < 555) {
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y)
            } else {
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: 554)
            }
            
            gestureRecognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
