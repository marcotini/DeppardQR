//
//  FIRCell.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class FIRCell: UICollectionViewCell {
    
    // This is the cells model
    var datasourceItem: Any?
    weak var controller: FIRCollectionViewController?
    
    let separatorLine: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        lineView.isHidden = true
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Hello")
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Override this to create views
    func setupViews() { }
    
}
