//
//  CollectionViewCell.swift
//  QRTests
//
//  Created by Harry Wright on 28/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

/**
 
 */
public class CollectionViewCell: UICollectionViewCell {
    
    static let reuseId: String = "CollectionViewCell"
    
    var datasourceItem: Any?
    
    weak var controller: CollectionViewController?
    
}

/**
 For Code built collection views
 */
public class CodeCollectionViewCell: CollectionViewCell {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
