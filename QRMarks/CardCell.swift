//
//  CardCell.swift
//  QRMarks
//
//  Created by Harry Wright on 20/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class CardCell: FIRCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
    }
}
