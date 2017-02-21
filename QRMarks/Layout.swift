//
//  Layout.swift
//  QRMarks
//
//  Created by Harry Wright on 20/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit


open class Layout: UICollectionViewLayout {
    
    let cardHeadHeight: CGFloat = 80
    
    var cardShouldExpandHeadHeight: Bool = true {
        didSet {
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
    
    var cardShouldStretchAtScrollTop: Bool = true
    
    var cardMaximumHeight: CGFloat = 200 {
        didSet {
            if(cardMaximumHeight < cardHeadHeight) {
                self.cardMaximumHeight = cardHeadHeight
                
                return
            }
            
            self.collectionView?.performBatchUpdates({ self.invalidateLayout() }, completion: nil)
        }
    }
}
