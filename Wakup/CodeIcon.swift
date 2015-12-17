//
//  CodeIcon.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 09/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

typealias IconDrawMethod = (frame: CGRect, color: UIColor) -> Void

class CodeIcon {
    
    let drawMethod: IconDrawMethod
    let aspectRatio: CGFloat
    
    init(drawMethod: IconDrawMethod, aspectRatio: CGFloat) {
        self.drawMethod = drawMethod
        self.aspectRatio = aspectRatio
    }
    
    convenience init(iconIdentifier: String) {
        let (drawMethod, aspectRatio) = CodeIconLibrary.drawMethodForIcon(iconIdentifier: iconIdentifier)
        self.init(drawMethod: drawMethod, aspectRatio: aspectRatio)
    }
    
    func draw(color: UIColor, frame: CGRect) {
        getCodeImage(forColor: color).draw(frame)
    }
    
    func getImage(color: UIColor, frame: CGRect) -> UIImage {
        return getCodeImage(forColor: color).getImage(frame)
    }
    
    func getCodeImage(forColor color: UIColor) -> CodeImage {
        return CodeImage(drawMethod: { frame in self.drawMethod(frame: frame, color: color) }, aspectRatio: self.aspectRatio)
    }
}