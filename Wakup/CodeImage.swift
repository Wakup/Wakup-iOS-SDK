//
//  CodeImage.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 18/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

public typealias DrawMethod = (_ frame: CGRect) -> Void

open class CodeImage {
    
    let drawMethod: DrawMethod
    let aspectRatio: CGFloat
    
    public init(drawMethod: @escaping DrawMethod, aspectRatio: CGFloat) {
        self.drawMethod = drawMethod
        self.aspectRatio = aspectRatio
    }
    
    func draw(_ frame: CGRect) {
        let adjustedFrame = CodeImage.getFrame(forFrame: frame, withAspectRatio: aspectRatio)
        drawMethod(adjustedFrame)
    }
    
    func getImage(_ frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        draw(frame)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    // Obtains a frame to draw the icon without distortion with the specified aspect ratio
    // Aspect ratio: width / height
    class func getFrame(forFrame frame: CGRect, withAspectRatio aspectRatio: CGFloat) -> CGRect {
        let size = frame.size
        let sizeToAdjustRatio = size.width / size.height
        var adjustedSize: CGSize!
        if sizeToAdjustRatio > aspectRatio {
            adjustedSize = CGSize(width: size.height * aspectRatio, height: size.height)
        }
        else {
            adjustedSize = CGSize(width: size.width, height: size.width / aspectRatio)
        }
        
        let adjustedOrigin = CGPoint(x: fabs(size.width - adjustedSize.width) / 2 + frame.origin.x, y: fabs(size.height - adjustedSize.height) / 2 + frame.origin.y)
        
        return CGRect(x: adjustedOrigin.x, y: adjustedOrigin.y, width: adjustedSize.width, height: adjustedSize.height)
    }
}
