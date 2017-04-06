//
//  CustomError.swift
//  QRMarks
//
//  Created by Harry Wright on 13/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import Foundation

/**
 Custom errors for when issues happen after the code passes:
 
 if error != nil
 
 Inside the `FIRAuth.auth()` function calls
 */
public struct AMError: Error, CustomDebugStringConvertible {
    
    private(set) var source: String = "", reason: String = ""
    
    public var localizedDescription: String { return "\(reason):\(source)" }
    
    public var debugDescription: String { return localizedDescription }
    
    public enum errorType: String {
        case guardFail = "Guard statement failed"
    }
    
    init(withSource sourceFile: String = #file, sourceFunction: String = #function) {
        self.source = "\(sourceFile):\(sourceFunction)"; self.reason = "Unknown"
    }
    
    init(withType type: errorType, for sourceFile: String = #file, sourceFunction: String = #function) {
        self.reason = type.rawValue; self.source = "\(sourceFile):\(sourceFunction)"
    }
    
    fileprivate init(reason: String, source: String) {
        self.reason = reason; self.source = source
    }
    
}

extension AMError {
    
    static func customError(withReason reason: String, forSource source: Any...) -> AMError {
        let sourceString = source.map{"\($0)"}.joined(separator: ", ")
        return self.init(reason: reason, source: sourceString)
    }
}

extension Error {
    
    func record() {
        Analytics.logError(by: User.main, for: self)
    }
    
}
