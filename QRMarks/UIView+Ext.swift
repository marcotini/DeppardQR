//
//  UIView+Ext.swift
//  QRMarks
//
//  Created by Harry Wright on 08/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

/**
 Extension to add shadow to views like sketch
 */
extension UIView {
    
    func sketchShadow(for colour: CGColor,_ opacity: Float,_ radius: CGFloat,_ size: CGSize) {
        layer.shadowColor = colour
        layer.shadowOffset = size // control x and y
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius // blur
        layer.masksToBounds = false
    }
    
    open func addSketchShadow() {
        sketchShadow(for: UIColor.cgShadow, 0.5, 4.0, CGSize(width: 0,height: 2))
    }
    
    open func addSketchNavShadow() {
        sketchShadow(for: UIColor.cgShadow, 0.7, 6.0, CGSize(width: 0, height: 4))
    }
    
    open func addRoundedShadow() {
        sketchShadow(for: UIColor.cgShadow, 0.7, 10, CGSize.zero)
    }
    
    open func removeShadow() {
        sketchShadow(for: UIColor.clear.cgColor, 0.0, 0.0, CGSize.zero)
    }
}
