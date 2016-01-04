//
//  CodeImage.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 18/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

public typealias DrawMethod = (frame: CGRect) -> Void

public class CodeImage {
    
    let drawMethod: DrawMethod
    let aspectRatio: CGFloat
    
    public init(drawMethod: DrawMethod, aspectRatio: CGFloat) {
        self.drawMethod = drawMethod
        self.aspectRatio = aspectRatio
    }
    
    func draw(frame: CGRect) {
        let adjustedFrame = CodeImage.getFrame(forFrame: frame, withAspectRatio: aspectRatio)
        drawMethod(frame: adjustedFrame)
    }
    
    func getImage(frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        draw(frame)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // Obtains a frame to draw the icon without distortion with the specified aspect ratio
    // Aspect ratio: width / height
    class func getFrame(forFrame frame: CGRect, withAspectRatio aspectRatio: CGFloat) -> CGRect {
        let size = frame.size
        let sizeToAdjustRatio = size.width / size.height
        var adjustedSize: CGSize!
        if sizeToAdjustRatio > aspectRatio {
            adjustedSize = CGSizeMake(size.height * aspectRatio, size.height)
        }
        else {
            adjustedSize = CGSizeMake(size.width, size.width / aspectRatio)
        }
        
        let adjustedOrigin = CGPointMake(fabs(size.width - adjustedSize.width) / 2 + frame.origin.x, fabs(size.height - adjustedSize.height) / 2 + frame.origin.y)
        
        return CGRectMake(adjustedOrigin.x, adjustedOrigin.y, adjustedSize.width, adjustedSize.height)
    }
}