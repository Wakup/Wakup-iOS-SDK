//
//  UICollectionView+CellUtils.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 29/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func scrollToIndexPathIfNotVisible(indexPath: NSIndexPath) {
        let visibleIndexPaths = self.indexPathsForVisibleItems() 
        if (!visibleIndexPaths.contains(indexPath)) {
            self.scrollToItemAtIndexPath(indexPath, atScrollPosition: [.CenteredVertically, .CenteredHorizontally], animated: false)
        }
    }
    
    func scrollToAndGetCell(atIndexPath indexPath: NSIndexPath) -> UICollectionViewCell! {
        scrollToIndexPathIfNotVisible(indexPath)
        self.layoutIfNeeded()
        return self.cellForItemAtIndexPath(indexPath)
    }
}