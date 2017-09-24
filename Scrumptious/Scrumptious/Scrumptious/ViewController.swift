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
    
    var businessCards: [SCNNode] = []
    
    var businessButtons: [SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.isUserInteractionEnabled = true
        activityIndicatorBack.isHidden = true
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognize:)))
        tapGesture.delegate = self
        sceneView.addGestureRecognizer(tapGesture)
        
        let gestureUp = UISwipeGestureRecognizer(target: self, action: #selector(gestureSegue))
        gestureUp.direction = .up
        nearYouView.addGestureRecognizer(gestureUp)
        
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
        
        for node in shopCards {
            node.removeFromParentNode()
        }
        
        for back in imageBacks {
            back.removeFromSuperview()
        }
        
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
            print("latitude", locationManager.location!.coordinate.latitude)
            print("longitude", locationManager.location!.coordinate.longitude)
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
    
    @objc func handleTap(gestureRecognize: UITapGestureRecognizer) {
        
        print("TAPPED")
        activityIndicatorBack.isHidden = false
        crosshairView.isHidden = true
        tipLbl.isHidden = true
        // Loader
        activityIndicatorBack.frame = CGRect(x: (sceneView.frame.size.width / 2) - 75, y: sceneView.frame.size.height / 2 - 60, width: 150, height: 50)
        activityIndicatorBack.backgroundColor = UIColor(red: 246/255, green: 218/255, blue: 77/255, alpha: 1.0)
        activityIndicatorBack.layer.cornerRadius = 6
        sceneView.addSubview(activityIndicatorBack)
        
        activityIndicatorView.frame = CGRect(x: 5, y: (activityIndicatorBack.frame.size.height / 2) - 25, width: 50, height: 50)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        activityIndicatorBack.addSubview(activityIndicatorView)
        
        loadingLbl.text = "LOADING"
        loadingLbl.textAlignment = .left
        loadingLbl.textColor = UIColor.white
        loadingLbl.font = UIFont(name: "Avenir-Medium", size: 16)
        loadingLbl.frame = CGRect(x: activityIndicatorView.frame.maxX, y: 0, width: activityIndicatorBack.frame.size.width - activityIndicatorView.frame.maxX, height: 50)
        activityIndicatorBack.addSubview(loadingLbl)
       
        // Start Animation
        activityIndicatorView.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Takes Image
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        var image = convertCItoUIImage(cmage: ciImage)
        image = image.crop(to: CGSize(width: image.size.width, height: image.size.width))
        image = image.zoom(to: 4.0) ?? image
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { success, error in
            if success {
                print("Saved successfully")
                // Saved successfully!
            }
        })

        GoogleAPIManager.shared().identify(image: image, completionHandler: { (result) in
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorBack.isHidden = true
            self.crosshairView.isHidden = false
            self.tipLbl.isHidden = false
            UIApplication.shared.endIgnoringInteractionEvents()
            
            //Assign Values to Cell
        })
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorBack.isHidden = true
        self.crosshairView.isHidden = false
        self.tipLbl.isHidden = false
        UIApplication.shared.endIgnoringInteractionEvents()
        
        print("Should stop loading")
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
    
    @objc func handleTap(gestureRecognize: UITapGestureRecognizer) {
        
        if fetchingResults == false {
            fetchingResults = true

            let screenCentre: CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
        
            let arHitTestResults: [ARHitTestResult] = sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
            guard let closestResult = arHitTestResults.first else {
                stopLoader()
                return
            }
            
            startLoader()

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
            let imageView = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 600))
            imageView.backgroundColor = .clear
            imageView.alpha = 1.0
            self.imageBacks.append(imageView)
            
            titleLabel.frame = CGRect(x: 30, y: 30, width: imageView.frame.width-128, height: 84)
            titleLabel.textAlignment = .left
            titleLabel.numberOfLines = 1
            titleLabel.font = UIFont(name: "Avenir", size: 84)
            titleLabel.backgroundColor = .clear
            titleLabel.text = "Chipotle"
            imageView.addSubview(titleLabel)
            
            let typeImg = UIImageView()
            typeImg.frame = CGRect(x: 640, y: 2, width: 140, height: 140)
            typeImg.contentMode = .scaleAspectFill
            typeImg.layer.cornerRadius = 70
            typeImg.layer.masksToBounds = true
            typeImg.image = UIImage(named: "foodicon")
            imageView.addSubview(typeImg)
        
//            lastTakenLabel.frame = CGRect(x: 40, y: 440, width: imageView.frame.width-80, height: 42)
//            lastTakenLabel.textAlignment = .left
//            lastTakenLabel.numberOfLines = 1
//            lastTakenLabel.font = UIFont(name: "Avenir", size: 30)
//            lastTakenLabel.text = "Friends that've been here"
//            lastTakenLabel.backgroundColor = .clear
//            imageView.addSubview(lastTakenLabel)
            
            let starsImg = UIImageView()
            starsImg.frame = CGRect(x: 25, y: 160, width: 400, height: 42)
            starsImg.contentMode = .scaleAspectFill
            starsImg.image = UIImage(named: "5stars")
            imageView.addSubview(starsImg)
            
            let friendImg1 = UIImageView()
            friendImg1.frame = CGRect(x: 25, y: 450, width: 120, height: 120)
            friendImg1.contentMode = .scaleAspectFill
            friendImg1.layer.cornerRadius = 60
            friendImg1.layer.masksToBounds = true
            friendImg1.image = UIImage(named: "pic0")
            imageView.addSubview(friendImg1)
            
            let friendImg2 = UIImageView()
            friendImg2.frame = CGRect(x: 180, y: 450, width: 120, height: 120)
            friendImg2.contentMode = .scaleAspectFill
            friendImg2.layer.cornerRadius = 60
            friendImg2.layer.masksToBounds = true
            friendImg2.image = UIImage(named: "pic1")
            imageView.addSubview(friendImg2)
            
            let friendImg3 = UIImageView()
            friendImg3.frame = CGRect(x: 340, y: 450, width: 120, height: 120)
            friendImg3.contentMode = .scaleAspectFill
            friendImg3.layer.cornerRadius = 60
            friendImg3.layer.masksToBounds = true
            friendImg3.image = UIImage(named: "pic0")
            imageView.addSubview(friendImg3)
            
            let friendImg4 = UIImageView()
            friendImg4.frame = CGRect(x: 500, y: 450, width: 120, height: 120)
            friendImg4.contentMode = .scaleAspectFill
            friendImg4.layer.cornerRadius = 60
            friendImg4.layer.masksToBounds = true
            friendImg4.image = UIImage(named: "pic0")
            imageView.addSubview(friendImg4)
            
            let friendImg5 = UIImageView()
            friendImg5.frame = CGRect(x: 660, y: 450, width: 120, height: 120)
            friendImg5.contentMode = .scaleAspectFill
            friendImg5.layer.cornerRadius = 60
            friendImg5.layer.masksToBounds = true
            friendImg5.image = UIImage(named: "pic1")
            imageView.addSubview(friendImg5)
            
            limitLabel.frame = CGRect(x: 0, y: 270, width: 400, height: 63)
            limitLabel.textAlignment = .center
            limitLabel.numberOfLines = 1
            limitLabel.font = UIFont(name: "Avenir", size: 70)
            limitLabel.text = "\(waitTime) min"
            limitLabel.backgroundColor = .clear
            imageView.addSubview(limitLabel)
        
            refillLabel.frame = CGRect(x: 0, y: 360, width: 400, height: 42)
            refillLabel.textAlignment = .center
            refillLabel.numberOfLines = 1
            refillLabel.font = UIFont(name: "Avenir-Medium", size: 42)
            refillLabel.text = "WAIT"
            refillLabel.backgroundColor = .clear
            refillLabel.textColor = UIColor.darkGray
            imageView.addSubview(refillLabel)
            
            let priceTxt = UILabel()
            priceTxt.frame = CGRect(x: 400, y: 270, width: 400, height: 63)
            priceTxt.textAlignment = .center
            priceTxt.numberOfLines = 1
            priceTxt.font = UIFont(name: "Avenir", size: 70)
            priceTxt.text = "$$$"
            priceTxt.backgroundColor = .clear
            imageView.addSubview(priceTxt)
            
            let priceSub = UILabel()
            priceSub.frame = CGRect(x: 400, y: 360, width: 400, height: 42)
            priceSub.textAlignment = .center
            priceSub.numberOfLines = 1
            priceSub.font = UIFont(name: "Avenir-Medium", size: 42)
            priceSub.text = "PRICE"
            priceSub.backgroundColor = .clear
            priceSub.textColor = UIColor.darkGray
            imageView.addSubview(priceSub)
        
            let texture = UIImage.imageWithView(view: imageView)
        
            let infoNode = SCNNode()
            let infoGeometry = SCNPlane(width: 0.13, height: 0.09)
            
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
            self.shopCards.append(infoNode)
        
        }
        
        fetchingResults = false
        stopLoader()
    }
}

extension UIImage {
    
    func crop(to:CGSize) -> UIImage {
        guard let cgimage = self.cgImage else { return self }
        
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        
        let contextSize: CGSize = contextImage.size
        
        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height
        
        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height
        
        if to.width > to.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if to.width < to.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: .right)
        
        UIGraphicsBeginImageContextWithOptions(to, true, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resized!
    }
    
    func zoom(to scale: CGFloat) -> UIImage? {
        var sideLength: CGFloat = 0;
        let imageHeight = self.size.height
        let imageWidth = self.size.width
        
        if imageHeight > imageWidth {
            sideLength = imageWidth
        }
        else {
            sideLength = imageHeight
        }
        
        let size = CGSize(width: sideLength, height: sideLength)
        
        let x = (size.width / 2) - (size.width / (2 * scale))
        let y = (size.height / 2) - (size.width / (2 * scale))
        
        let cropRect = CGRect(x: x, y: y, width: size.width / scale, height: size.height / scale)
        if let imageRef = cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 1.0, orientation: imageOrientation)
        }
        
        return nil
    }
}


extension UIImage {
    class func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
