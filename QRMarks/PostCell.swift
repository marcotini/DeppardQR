//
//  PostCell.swift
//  QRMarks
//
//  Created by Harry Wright on 08/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import HWCollectionView

class PostCell: IBCollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override var datasourceItem: Any? {
        didSet {
            configCell()
        }
    }
    
    override func configCell() {
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 12
        
        let backgroundColor = containerView.backgroundColor
        companyLabel.textColor = UIColor.headerTextColor(on: backgroundColor!)
        nameLabel.textColor = UIColor.subheaderTextColor(on: backgroundColor!)
        
        guard let post = datasourceItem as! Posts? else { return }
        companyLabel.text = post.companyName ?? "Unknown"
        nameLabel.text = post.name ?? "Unknown"
        
    }
}
