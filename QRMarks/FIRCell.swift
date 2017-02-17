//
//  FIRCell.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

/**
 New Hip Subclass of UICollectionViewCell that is brought to you by FIRCollectionView package.
 
 This Cell allows for easier view setup and UI updation, also by overriding the `datasourceItem` you can set the cells object and work with downloaded/array data from there, all with minimal code been written
 */
class FIRCell: UICollectionViewCell {
    
    /// This is the cells model.
    ///
    /// Any UI Changes should call `UIUpdate()` inside `didSet`
    var datasourceItem: Any?
    
    /// The View Controller been used, incase needed to reload data or control the view
    weak var controller: FIRCollectionViewController?
    
    /// Seperator Line that can be used by calling `seperatorLine.isHidden = false`
    let separatorLine: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        lineView.isHidden = true
        return lineView
    }()
    
    /// Init that sets the frame and calls the `setupViews()` method
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Hello")
        
        setupViews()
    }
    
    /// Required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Override this to create views
    ///
    /// Used to create the views when adding new views
    func setupViews() {
        addSubview(separatorLine)
        separatorLine.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    /// Function to be overwritten when updating UI, call this inside `datasourceItem didSet`
    func UIUpdate() { }
    
}
