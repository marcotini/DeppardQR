//
//  Test Cell.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class PostCell: FIRCell {
    
    let nameLabel = UILabel()
    private var _post: Posts! = nil
    
    override var datasourceItem: Any? {
        didSet {
            if let item = datasourceItem as? Posts {
                _post = item
                
                UIUpdate()
            } else {
                print(datasourceItem.debugDescription)
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        separatorLine.isHidden = false
        
        nameLabel.textColor = .darkGray
        backgroundColor = .white
        
        self.addSubview(nameLabel)
        nameLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    
    override func UIUpdate() {
        super.UIUpdate()
        
        let name = _post?.companyName ?? "null"
        nameLabel.text = name
        
    }
}
