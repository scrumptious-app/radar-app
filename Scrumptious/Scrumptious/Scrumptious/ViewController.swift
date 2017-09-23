//
//  ViewController.swift
//  Scrumptious
//
//  Created by Brian Nunes De Souza on 9/23/17.
//  Copyright © 2017 scrumptious. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let topTableView = UIView()
    var mainListVC: MainListVC?
    var tapGesture = UITapGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    
    let showListBtn = UIButton()
    let nearYouView = UIView()
    let nearYouLbl = UILabel()
    let nearYouImg = UIImageView()
    let tipLbl = UILabel()
    
    let crosshairView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognize:)))
//        tapGesture.delegate = self
//        view.addGestureRecognizer(tapGesture)
        let gestureUp = UISwipeGestureRecognizer(target: self, action: #selector(gestureSegue))
        gestureUp.direction = .up
        nearYouView.addGestureRecognizer(gestureUp)
        
        nearYouView.frame = CGRect(x: 0.0, y: sceneView.frame.size.height - 80, width: sceneView.frame.size.width, height: 80.0)
        nearYouView.backgroundColor = UIColor(red: 246/255, green: 218/255, blue: 77/255, alpha: 1.0)
        sceneView.addSubview(nearYouView)
        
        nearYouImg.frame = CGRect(x: nearYouView.frame.size.width - 60, y: (nearYouView.frame.size.height / 2) - 15, width: 30.0, height: 30.0)
        nearYouImg.image = UIImage(named: "arrowup")
        nearYouView.addSubview(nearYouImg)
        
        //showListBtn.backgroundColor = UIColor.blue
        showListBtn.frame = CGRect(x: nearYouView.frame.size.width - 80, y: (nearYouView.frame.size.height / 2) - 30, width: 60.0, height: 60.0)
        showListBtn.addTarget(self, action: #selector(showListPressed), for: .touchUpInside)
        nearYouView.addSubview(showListBtn)
        
        nearYouLbl.font = UIFont(name: "Avenir-Heavy", size: 22.0)
        nearYouLbl.text = "All Near You"
        nearYouLbl.textAlignment = .left
        nearYouLbl.textColor = UIColor.white
        nearYouLbl.frame = CGRect(x: 20, y: (nearYouView.frame.size.height / 2) - 12, width: nearYouView.frame.size.width - 100, height: 24.0)
        nearYouView.addSubview(nearYouLbl)
        
        crosshairView.frame = CGRect(x: sceneView.frame.size.width / 2 - 50, y: sceneView.frame.size.height / 2 - 90, width: 100, height: 100)
        crosshairView.image = UIImage(named: "focus2")
        sceneView.addSubview(crosshairView)
        
        tipLbl.font = UIFont(name: "Avenir Medium", size: 22)
        tipLbl.text = "Point towards a storefront"
        tipLbl.textAlignment = .center
        tipLbl.textColor = UIColor.white
        tipLbl.frame = CGRect(x: 0, y: 60, width: sceneView.frame.size.width, height: 20)
        sceneView.addSubview(tipLbl)
        
        // Pulsing
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1.2
        pulseAnimation.fromValue = 0.1
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        tipLbl.layer.add(pulseAnimation, forKey: nil)
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        // let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        // sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Enable plane detection
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        
        nearYouView.roundCorners(corners: [.topLeft , .topRight], radius: 16)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc func showListPressed() {
        self.performSegue(withIdentifier: "showList", sender: nil)
    }
    
    @objc func gestureSegue() {
        self.performSegue(withIdentifier: "showList", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }
}
