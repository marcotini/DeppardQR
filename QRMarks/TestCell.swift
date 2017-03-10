//
//  TestCell.swift
//  QRMarks
//
//  Created by Harry Wright on 09/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import HWCollectionView

class TestCell: IBCollectionViewCell {
    
    @IBOutlet weak var cornerView: UIView!
    
    override func configCell() {
        self.cornerView.round(corners: [.topRight, .topLeft], radius: 12)
    }
    
}
