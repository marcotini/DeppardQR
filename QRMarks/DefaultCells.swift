//
//  DefaultCells.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class defaultCell: FIRCell {
    
    let label = UILabel()
    
    override var datasourceItem: Any? {
        didSet {
            if let text = datasourceItem as? String {
                label.text = text
            } else {
                label.text = datasourceItem.debugDescription
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(label)
        label.default()
    }
    
    override var reuseIdentifier: String? {
        return defaultCell.string
    }
    
}

