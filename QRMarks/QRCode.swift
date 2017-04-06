//
//  QRCode.swift
//  QRMarks
//
//  Created by Harry Wright on 18/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import FIFIlter

enum QRParameter: String {
    
    case L = "L"
    
    case M = "M"
    
    case Q = "Q"
    
    case H = "H"
    
    init(withLetter letter: String) {
        switch letter.uppercased() {
        case "L" : self = .L
        case "M" : self = .M
        case "Q" : self = .Q
        case "H" : self = .H
        default : self = .M
        }
    }
    
}

@IBDesignable
class QRCode: UIImageView {
    
    var correctionLevel: QRParameter = .H
    
    var message: String = "default" {
        didSet {
            createQR()
        }
    }
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'correctionLevel' instead.")
    @IBInspectable
    var correctionLevelLetter: String? {
        willSet {
            if let newLetter = QRParameter(withLetter: newValue?.uppercased() ?? "") as QRParameter? {
                self.correctionLevel = newLetter
            }
        }
    }
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'message' instead.")
    @IBInspectable
    var messageForCode: String? {
        willSet {
            self.message = newValue!
        }
    }
    
    private var parameter: CIParameter = CIParameter.inputCorrectionLevel
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createQR()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createQR()
    }
    
    init(withMessage message: String, correctionLevel: QRParameter) {
        self.correctionLevel = correctionLevel
        self.message = message
        
        super.init(image: nil)
    }
    
    private func createQR() {
        let parameters: [Parameter] = [(self.parameter, correctionLevel.rawValue)]
        self.image = FIImage.qrCode(message: message.data,
                                    imageView: self,
                                    parameters: parameters)
    }
    
}
