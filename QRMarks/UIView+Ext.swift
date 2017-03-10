//
//  UIView+Ext.swift
//  QRMarks
//
//  Created by Harry Wright on 08/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {
    
    @IBInspectable var shadowColor: UIColor = .clear
    
    @IBInspectable var opacity: Float = 0.5
    
    @IBInspectable var radius: CGFloat = 4
    
    @IBInspectable var size: CGSize = CGSize(width: 0, height: 2)
    
    @IBInspectable var addShadow: Bool = false {
        didSet {
            if self.addShadow {
                self.addSketchShadow(for: self.shadowColor, self.opacity, self.radius, self.size)
            }
        }
    }
    
}

/**
 Extension to add shadow to views like sketch
 */
extension UIView {
    
    func addSketchShadow(for colour: UIColor, _ opacity: Float, _ radius: CGFloat, _ size: CGSize) {
        layer.shadowColor = colour.cgColor
        layer.shadowOffset = size // control x and y
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius // blur
        layer.masksToBounds = false
    }
    
    open func addSketchShadow() {
        addSketchShadow(for: .shadowColour, 0.5, 4.0, CGSize(width: 0,height: 2))
    }
    
    open func addSketchNavShadow() {
        addSketchShadow(for: .shadowColour, 0.7, 6.0, CGSize(width: 0, height: 4))
    }
    
    open func addRoundedShadow() {
        addSketchShadow(for: .shadowColour, 0.7, 10, CGSize.zero)
    }
    
    open func removeShadow() {
        addSketchShadow(for: .shadowColour, 0.0, 0.0, CGSize.zero)
    }
    
    open func addTopCorner() {
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 20, height:  20))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
    }
}

@IBDesignable
class roundCorners: UIView {
    
    var corners: UIRectCorner?
    
    @IBInspectable var topCorners: Bool = false {
        didSet {
            if self.topCorners == true {
                corners = [.topLeft, .topRight]
                self.setup(corners: corners, withRadius: self.cornerRadius)
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0
    
    func setup(corners: UIRectCorner? = [.topLeft, .topRight], withRadius radius: CGFloat? = 0.0) {
        self.round(corners: self.corners, radius: self.cornerRadius)
    }
}

class shadowedView: roundCorners {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup(corners: UIRectCorner?, withRadius radius: CGFloat?) {
        super.setup(corners: corners, withRadius: radius)
        self.addRoundedShadow()
    }
    
}

extension UIView {

    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner? = [.allCorners], radius: CGFloat) {
        _round(corners: corners!, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
}

private extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}

extension UINavigationBar {
    
    func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView!.isHidden = true
    }
    
    func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView!.isHidden = false
    }
    
    fileprivate func hairlineImageViewInNavigationBar(_ view: UIView) -> UIImageView? {
        if view.isKind(of: UIImageView.self) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInNavigationBar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
}
