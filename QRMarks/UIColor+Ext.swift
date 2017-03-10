//
//  UIColor+Ext.swift
//  QRMarks
//
//  Created by Harry Wright on 08/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// White (0xFFFFFF) with 100% Alpha
    fileprivate class var primaryDarkBGHeader: UIColor {
        let colour = UIColor(netHex: 0xFFFFFF)
        return colour.withAlphaComponent(1)
    }
    
    /// White (0xFFFFFF) with 70% Alpha
    fileprivate class var secondayDarkBGHeader: UIColor {
        let colour = UIColor(netHex: 0xFFFFFF)
        return colour.withAlphaComponent(0.7)
    }
    
    /// Black (0x000000) with 87% Alpha
    fileprivate class var primarylightBGHeader: UIColor {
        let colour = UIColor(netHex: 0x000000)
        return colour.withAlphaComponent(0.87)
    }
    
    /// Black (0x000000) with 50% Alpha
    fileprivate class var secondarylightBGHeader: UIColor {
        let colour = UIColor(netHex: 0x000000)
        return colour.withAlphaComponent(0.50)
    }
    
    class var shadowColour: UIColor {
        let colour = UIColor.black.withAlphaComponent(0.5)
        return colour
    }
    
    class var cgShadow: CGColor {
        return UIColor.shadowColour.cgColor
    }
}

extension UIColor {

    ///
    class func headerTextColor(on color: UIColor) -> UIColor {
        if color.isLight {
            return .primarylightBGHeader
        } else {
            return .primaryDarkBGHeader
        }
    }
    
    ///
    class func subheaderTextColor(on color: UIColor) -> UIColor {
        if color.isLight {
            return .secondarylightBGHeader
        } else {
            return .secondayDarkBGHeader
        }
    }
    
    ///
    private var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}
