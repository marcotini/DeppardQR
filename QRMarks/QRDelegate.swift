//
//  UIDelegate.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

@objc protocol QRDelegate: class {
    func reloadUI(with image: UIImage)
}
