//
//  UICollectionViewFlowLayout+Extension.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2018/11/28.
//  Copyright © 2018 Xuenn Pte Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewFlowLayout {
    
    func with(minimumLineSpacing: CGFloat) -> Self {
        self.minimumLineSpacing = minimumLineSpacing
        return self
    }
    
    func with(minimumInteritemSpacing: CGFloat) -> Self {
        self.minimumInteritemSpacing = minimumInteritemSpacing
        return self
    }
    
    func with(sectionInset: UIEdgeInsets) -> Self {
        self.sectionInset = sectionInset
        return self
    }
    
    func with(estimatedItemSize: CGSize) -> Self {
        self.estimatedItemSize = estimatedItemSize
        return self
    }
    
    func with(itemSize: CGSize) -> Self {
        self.itemSize = itemSize
        return self
    }
}
