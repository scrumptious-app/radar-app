//
//  Extensions.swift
//  Scrumptious
//
//  Created by Brian Nunes De Souza on 9/23/17.
//  Copyright © 2017 scrumptious. All rights reserved.
//

import Foundation
import UIKit

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

func convertCItoUIImage(cmage:CIImage) -> UIImage
{
    let context:CIContext = CIContext.init(options: nil)
    
    let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
    return UIImage(cgImage: cgImage)
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
extension UIViewController{
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
}
