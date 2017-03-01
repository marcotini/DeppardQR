//
//  CollectionViewCell.swift
//  QRTests
//
//  Created by Harry Wright on 28/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

/**
 Subclass of `UICollectionViewCell` to set the classes with the controller and datasourceItem, this allow for easier set up of the cell
 */
public class CollectionViewCell: UICollectionViewCell {
    
    static let reuseId: String = "CollectionViewCell"
    
    weak var controller: CollectionViewController?
    
    var datasourceItem: Any? {
        didSet {
            configCell()
        }
    }
    
    func configCell() { }
    
    func setupViews() { }

}

/**
 Collection View Cell that inherits from the superclass `CollectionViewCell` that is setup to be used by using IB
 */
public class IBCollectionViewCell: CollectionViewCell {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(#function)
    }
    
    override func configCell() {
        print(#function)
    }
}

/**
 Collection View Cell that inherits from the superclass `CollectionViewCell` that is setup to be used by devolpers creating cells via code
 */
public class CodeCollectionViewCell: CollectionViewCell {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        print(#function)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configCell() {
        //
    }
    
    override func setupViews() {
        print(#function)
    }
    
}
