//
//  Delegate.swift
//  QRTests
//
//  Created by Harry Wright on 28/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import Foundation

/**
 
 */
@objc protocol CollectionViewDelegate: class {
    
    /// Function to register the cell classes inside the view controller
    ///
    /// Only needed if building collection view via code, as registering is required
    /// to tell the collection view the cells it is needing to look at
    @objc optional func register(_ cellClasses: [CollectionViewCell.Type])
}
