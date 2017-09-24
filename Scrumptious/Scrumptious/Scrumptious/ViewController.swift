
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
import SceneKit.ModelIO
import Vision
import Photos
import CoreLocation

struct Bools {
    static var fetchingResults = false
}

class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let topTableView = UIView()
    var tapGesture = UITapGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    var panDownGesture = UISwipeGestureRecognizer()
    var locationManager: CLLocationManager!
    
    let showListBtn = UIButton()
    let nearYouView = UIView()
    let nearYouLbl = UILabel()
    let nearYouImg = UIImageView()
    let tipLbl = UILabel()
    
    let crosshairView = UIImageView()
    var activityIndicatorView = UIActivityIndicatorView()
    var activityIndicatorBack = UIView()
    var loadingLbl = UILabel()
    
    var shopCards: [SCNNode] = []
    var imageBacks: [UIView] = []
    
    // Card Info
    let titleLabel = UILabel()
    let lastTakenLabel = UILabel()
    let limitLabel = UILabel()
    let refillLabel = UILabel()
    var waitTime = 5
    var firstTap = true
    let notifView = UIView()
    let notifTxt = UILabel()
    let imageView = UIView()
    
    // Card Values
    var cat = String()
    var rating = Double()
    var name = String()
    var price = String()
    //var image = URL
    
    var nodeArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Top Notification
        notifView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: 20)
        notifView.alpha = 0
        sceneView.addSubview(notifView)
        
        notifTxt.font = UIFont(name: "Avenir", size: 12.0)
        notifTxt.frame = CGRect(x: 0.0, y: 0, width: view.frame.size.width, height: 20.0)
        notifTxt.textAlignment = .center
        notifTxt.textColor = UIColor.white
        notifView.addSubview(notifTxt)
        
        // Making Loader
        activityIndicatorBack.backgroundColor = UIColor(red: 246/255, green: 218/255, blue: 77/255, alpha: 1.0)
        activityIndicatorBack.layer.cornerRadius = 6
        activityIndicatorBack.frame = CGRect(x: (sceneView.frame.size.width / 2) - 80, y: sceneView.frame.size.height / 2 - 70, width: 160, height: 60)
        sceneView.addSubview(activityIndicatorBack)
        
        activityIndicatorView.activityIndicatorViewStyle = .white
        activityIndicatorView.frame = CGRect(x: 5, y: 0, width: 60, height: 60)
        activityIndicatorBack.addSubview(activityIndicatorView)
        
        loadingLbl.font = UIFont(name: "Avenir-Medium", size: 16)
        loadingLbl.textColor = UIColor.white
        loadingLbl.textAlignment = .left
        loadingLbl.text = "LOADING"
        loadingLbl.frame = CGRect(x: 60, y: 0, width: activityIndicatorBack.frame.size.width - 60, height: 60)
        activityIndicatorBack.addSubview(loadingLbl)
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.isUserInteractionEnabled = true
        activityIndicatorBack.isHidden = true
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognize:)))
        tapGesture.delegate = self
        sceneView.addGestureRecognizer(tapGesture)
        
        let gestureUp = UISwipeGestureRecognizer(target: self, action: #selector(gestureSegue))
        gestureUp.direction = .up
        sceneView.addGestureRecognizer(gestureUp)
        
        panDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissVR))
        panDownGesture.direction = .down
        sceneView.addGestureRecognizer(panDownGesture)
        
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
        
        tipLbl.font = UIFont(name: "Avenir", size: 22)
        tipLbl.text = "Point towards a storefront"
        tipLbl.textAlignment = .center
        tipLbl.textColor = UIColor.white
        tipLbl.frame = CGRect(x: 0, y: 60, width: sceneView.frame.size.width, height: 20)
        sceneView.addSubview(tipLbl)
        
        // Pulsing
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1.2
        pulseAnimation.fromValue = 0.2
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
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func dismissVR() {
        
        //sceneView.session.pause()
        
        self.deleteNodes()
        shopCards.removeAll()
        imageBacks.removeAll()
        
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
        if locationManager != nil{
        }
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
    
    func stopLoader() {
        
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorBack.isHidden = true
        self.crosshairView.isHidden = false
        self.tipLbl.isHidden = false
        UIApplication.shared.endIgnoringInteractionEvents()
        
        print("Should stop loading")
    }
    
    func startLoader() {
        self.activityIndicatorView.startAnimating()
        self.activityIndicatorBack.isHidden = false
        self.crosshairView.isHidden = true
        self.tipLbl.isHidden = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        print("Should start loading")
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @objc func handleTap(gestureRecognizeNode: UITapGestureRecognizer) {
        
        print("Tapped Node")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @objc func handleTap(gestureRecognize: UITapGestureRecognizer) {
        
        if Bools.fetchingResults == false && firstTap == false {
            startLoader()
            
            let screenCentre: CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
            let arHitTestResults: [ARHitTestResult] = sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
            guard let closestResult = arHitTestResults.first else {
                stopLoader()
                return
            }
            
            //Takes Image
            let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
            if pixbuff == nil { return }
            let ciImage = CIImage(cvPixelBuffer: pixbuff!)
            var image = convertCItoUIImage(cmage: ciImage)
            image = image.crop(to: CGSize(width: image.size.width, height: image.size.width))
            image = image.zoom(to: 2.0) ?? image
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { success, error in
                if success {
                    print("Saved successfully")
                    // Saved successfully!
                }
            })
            
            
            
            GoogleAPIManager.shared().identify(image: image,lat:locationManager.location!.coordinate.latitude, lon: locationManager.location!.coordinate.longitude, completionHandler: { (result) in
                if result == nil{
                    self.stopLoader()
                    return
                } 
                else {
                    
                    // Get Coordinates of HitTest
                    let transform : matrix_float4x4 = closestResult.worldTransform
                    
                    let worldCoord = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                    
                    let billboardConstraint = SCNBillboardConstraint()
                    billboardConstraint.freeAxes = SCNBillboardAxis.Y
                    
                    let textNode = SCNNode()
                    textNode.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
                    textNode.opacity = 0.0
                    self.sceneView.scene.rootNode.addChildNode(textNode)
                    textNode.position = worldCoord
                    let backNode = SCNNode()
                    let plaque = SCNBox(width: 0.14, height: 0.1, length: 0.01, chamferRadius: 0.005)
                    plaque.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.6)
                    backNode.geometry = plaque
                    backNode.position.y += 0.09
                    
                    //Set up card view
                    self.imageView.frame = CGRect(x: 0, y: 0, width: 800, height: 600)
                    self.imageView.backgroundColor = .clear
                    self.imageView.alpha = 1.0
                    self.imageBacks.append(self.imageView)
                    
                    //            titleLabel.frame = CGRect(x: 30, y: 30, width: imageView.frame.width-128, height: 84)
                    //            titleLabel.textAlignment = .left
                    //            titleLabel.numberOfLines = 1
                    //            titleLabel.font = UIFont(name: "Avenir", size: 84)
                    //            titleLabel.backgroundColor = .clear
                    //            imageView.addSubview(titleLabel)
                    
                    let typeImg = UIImageView()
                    typeImg.frame = CGRect(x: 640, y: 2, width: 140, height: 140)
                    typeImg.contentMode = .scaleAspectFill
                    typeImg.layer.cornerRadius = 70
                    typeImg.layer.masksToBounds = true
                    typeImg.image = UIImage(named: "foodicon")
                    self.imageView.addSubview(typeImg)
                    
                    let starsImg = UIImageView()
                    starsImg.frame = CGRect(x: 25, y: 160, width: 400, height: 42)
                    starsImg.contentMode = .scaleAspectFill
                    //            imageView.addSubview(starsImg)
                    
                    //Friends Randomnizer
                    var friendsCount = arc4random_uniform(3)
                    
                    if friendsCount == 0{
                        friendsCount = 1
                    }
                    else if friendsCount == 1{
                        friendsCount = 3
                    }
                    else{
                        friendsCount = 5
                    }
                    
                    var friendList = [Int]()
                    for _ in 0..<friendsCount{
                        var tempInt = arc4random_uniform(9)
                        while friendList.contains(Int(tempInt)){
                            tempInt = arc4random_uniform(9)
                        }
                        friendList.append(Int(tempInt))
                    }
                    
                    if friendsCount >= 1{
                        let friendImg3 = UIImageView()
                        friendImg3.frame = CGRect(x: 340, y: 450, width: 120, height: 120)
                        friendImg3.contentMode = .scaleAspectFill
                        friendImg3.layer.cornerRadius = 60
                        friendImg3.layer.masksToBounds = true
                        friendImg3.image = UIImage(named: "pic\(friendList[0])")
                        self.imageView.addSubview(friendImg3)
                    }
                    
                    if friendsCount >= 3{
                        let friendImg2 = UIImageView()
                        friendImg2.frame = CGRect(x: 185, y: 450, width: 120, height: 120)
                        friendImg2.contentMode = .scaleAspectFill
                        friendImg2.layer.cornerRadius = 60
                        friendImg2.layer.masksToBounds = true
                        friendImg2.image = UIImage(named: "pic\(friendList[1])")
                        self.imageView.addSubview(friendImg2)
                        
                        let friendImg4 = UIImageView()
                        friendImg4.frame = CGRect(x: 500, y: 450, width: 120, height: 120)
                        friendImg4.contentMode = .scaleAspectFill
                        friendImg4.layer.cornerRadius = 60
                        friendImg4.layer.masksToBounds = true
                        friendImg4.image = UIImage(named: "pic\(friendList[2])")
                        self.imageView.addSubview(friendImg4)
                    }
                    
                    if friendsCount >= 5{
                        let friendImg1 = UIImageView()
                        friendImg1.frame = CGRect(x: 30, y: 450, width: 120, height: 120)
                        friendImg1.contentMode = .scaleAspectFill
                        friendImg1.layer.cornerRadius = 60
                        friendImg1.layer.masksToBounds = true
                        friendImg1.image = UIImage(named: "pic\(friendList[3])")
                        self.imageView.addSubview(friendImg1)
                        
                        let friendImg5 = UIImageView()
                        friendImg5.frame = CGRect(x: 660, y: 450, width: 120, height: 120)
                        friendImg5.contentMode = .scaleAspectFill
                        friendImg5.layer.cornerRadius = 60
                        friendImg5.layer.masksToBounds = true
                        friendImg5.image = UIImage(named: "pic\(friendList[4])")
                        self.imageView.addSubview(friendImg5)
                    }
                    
                    self.limitLabel.frame = CGRect(x: 0, y: 270, width: 400, height: 63)
                    self.limitLabel.textAlignment = .center
                    self.limitLabel.numberOfLines = 1
                    self.limitLabel.font = UIFont(name: "Avenir", size: 70)
                    self.limitLabel.text = "\(self.waitTime) min"
                    self.limitLabel.backgroundColor = .clear
                    self.imageView.addSubview(self.limitLabel)
                    
                    self.refillLabel.frame = CGRect(x: 0, y: 360, width: 400, height: 42)
                    self.refillLabel.textAlignment = .center
                    self.refillLabel.numberOfLines = 1
                    self.refillLabel.font = UIFont(name: "Avenir-Medium", size: 42)
                    self.refillLabel.text = "WAIT"
                    self.refillLabel.backgroundColor = .clear
                    self.refillLabel.textColor = UIColor.darkGray
                    self.imageView.addSubview(self.refillLabel)
                    
                    // Goes from $ to $$$
                    let priceTxt = UILabel()
                    //            priceTxt.frame = CGRect(x: 400, y: 270, width: 400, height: 63)
                    //            priceTxt.textAlignment = .center
                    //            priceTxt.numberOfLines = 1
                    //            priceTxt.font = UIFont(name: "Avenir", size: 70)
                    //            priceTxt.backgroundColor = .clear
                    //            imageView.addSubview(priceTxt)
                    
                    let priceSub = UILabel()
                    priceSub.frame = CGRect(x: 400, y: 360, width: 400, height: 42)
                    priceSub.textAlignment = .center
                    priceSub.numberOfLines = 1
                    priceSub.font = UIFont(name: "Avenir-Medium", size: 42)
                    priceSub.text = "PRICE"
                    priceSub.backgroundColor = .clear
                    priceSub.textColor = UIColor.darkGray
                    self.imageView.addSubview(priceSub)
                    
                    let texture = UIImage.imageWithView(view: self.imageView)
                    
                    let infoNode = SCNNode()
                    let infoGeometry = SCNPlane(width: 0.13, height: 0.09)
                    
                    //Setting Values for Business Card
                    self.cat = (result!.category)
                    self.rating = (result!.rating)
                    self.name = (result!.name)
                    self.price = (result!.price)
                
                
                // Price
                priceTxt.frame = CGRect(x: 400, y: 270, width: 400, height: 63)
                priceTxt.textAlignment = .center
                priceTxt.numberOfLines = 1
                priceTxt.font = UIFont(name: "Avenir", size: 70)
                priceTxt.backgroundColor = .clear
                priceTxt.text = result!.price
                
                // Title
                self.titleLabel.frame = CGRect(x: 30, y: 30, width: self.imageView.frame.width-128, height: 84)
                self.titleLabel.textAlignment = .left
                self.titleLabel.numberOfLines = 1
                self.titleLabel.font = UIFont(name: "Avenir", size: 84)
                self.titleLabel.backgroundColor = .clear
                self.titleLabel.text = result!.name.capitalized
                
                self.imageView.addSubview(starsImg)
                self.imageView.addSubview(self.titleLabel)
                self.imageView.addSubview(priceTxt)
                
//                //imageView.reloadInputViews()
//                self.titleLabel.setNeedsDisplay()
//                self.titleLabel.draw(CGRect(x: 30, y: 30, width: self.imageView.frame.width-128, height: 84))
//                priceTxt.setNeedsDisplay()
//                priceTxt.draw(CGRect(x: 400, y: 270, width: 400, height: 63))
                
                
                
                
                starsImg.image = UIImage(named: "\(Int(result!.rating))stars")
                
                infoGeometry.firstMaterial?.diffuse.contents = texture
                infoNode.geometry = infoGeometry
                infoNode.position.y += 0.09
                infoNode.position.z += 0.0055
                
                textNode.addChildNode(backNode)
                textNode.addChildNode(infoNode)
                
                textNode.constraints = [billboardConstraint]
                textNode.runAction(SCNAction.scale(to: 0.0, duration: 0))
                backNode.runAction(SCNAction.scale(to: 0.0, duration: 0))
                infoNode.runAction(SCNAction.scale(to: 0.0, duration: 0))
                textNode.runAction(SCNAction.fadeOpacity(to: 0.0, duration: 0))
                backNode.runAction(SCNAction.fadeOpacity(to: 0.0, duration: 0))
                infoNode.runAction(SCNAction.fadeOpacity(to: 0.0, duration: 0))
                
                textNode.runAction(SCNAction.wait(duration: 0.01))
                backNode.runAction(SCNAction.wait(duration: 0.01))
                infoNode.runAction(SCNAction.wait(duration: 0.01))
                textNode.runAction(SCNAction.scale(to: 1.0, duration: 0.3) )
                backNode.runAction(SCNAction.scale(to: 1.0, duration: 0.3) )
                infoNode.runAction(SCNAction.scale(to: 1.0, duration: 0.3) )
                textNode.runAction(SCNAction.fadeOpacity(to: 1.0, duration: 0.3))
                backNode.runAction(SCNAction.fadeOpacity(to: 1.0, duration: 0.3))
                infoNode.runAction(SCNAction.fadeOpacity(to: 1.0, duration: 0.3))
                
                //Save nodes in array
                self.nodeArray.append(infoNode)
                self.nodeArray.append(textNode)
                self.nodeArray.append(backNode)
                
                self.shopCards.append(infoNode)
                //self.image = (result?.image)!
                //(category: String, rating: Double, name: String, price: String, image: URL)
                }
                self.stopLoader()
            })
            print("price: ", price)
            print("title: ", name)
            
        } else if firstTap == true {
            
            failNotif(text: "COULD NOT PERFORM TASK")
            print("FIRST")
            stopLoader()
        } else if firstTap == true && Bools.fetchingResults == true {
            failNotif(text: "COULD NOT PERFORM TASK")
            print("FAKE NEWS")
            stopLoader()
        } else {
            failNotif(text: "COULD NOT PERFORM TASK")
            print("GETTING DATA")
            stopLoader()
        }
        
        firstTap = false
    }
    
    func fadeViewOutThenIn(view : UIView, delay: TimeInterval) {
        
        let animationDuration = 0.25
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 0
        }) { (Bool) -> Void in
            
            UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseInOut, animations: { () -> Void in
                view.alpha = 1
            }, completion: nil)
        }
    }
    
    func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
        
        let animationDuration = 0.25
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        }) { (Bool) -> Void in
            
            UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseInOut, animations: { () -> Void in
                view.alpha = 0
            }, completion: nil)
        }
    }
    
    func failNotif(text: String) {
        
        if text != "" {
            notifView.backgroundColor = UIColor.red
            notifTxt.text = text
            fadeViewInThenOut(view: notifView, delay: 2.0)
        }
        
    }
    
    func successNotif(text: String) {
        
        if text != "" {
            notifView.backgroundColor = UIColor.green
            notifTxt.text = text
            fadeViewInThenOut(view: notifView, delay: 2.0)
        }
        
    }
    
    func deleteNodes(){
        for node in nodeArray{
            node.removeFromParentNode()
        }
    }
}

