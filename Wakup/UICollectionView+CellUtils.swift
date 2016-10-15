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
    func scrollToIndexPathIfNotVisible(_ indexPath: IndexPath) {
        let visibleIndexPaths = self.indexPathsForVisibleItems 
        if (!visibleIndexPaths.contains(indexPath)) {
            self.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: false)
        }
    }
    
    func scrollToAndGetCell(atIndexPath indexPath: IndexPath) -> UICollectionViewCell! {
        scrollToIndexPathIfNotVisible(indexPath)
        self.layoutIfNeeded()
        return self.cellForItem(at: indexPath)
    }
}
