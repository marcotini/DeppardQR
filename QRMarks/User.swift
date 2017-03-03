//
//  User.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import Foundation

class User {
    internal var _uid: String?
    internal var _name: String?
    internal var _companyName: String?
    internal var _address: [String : String]?
    internal var _qrUrl: String?
    internal var _numbers: [String] = []
    internal var _scanned_url: String?
    private var _objects: Dictionary<String, AnyObject> = [:]
    
    static let main = User()
    static let viewed = User()
    
    var uid: String? {
        return _uid
    }
    
    var name: String? {
        return _name
    }
    
    var companyName: String? {
        return _companyName
    }
    
    var address: [String : String]? {
        return _address
    }
    
    var qrUrl: String? {
        // May look at seeing wether is worth even storing the qrUrl
        return _qrUrl ?? _uid
    }
    
    var numbers: [String]? {
        return _numbers
    }
    
    var scanned_url: String? {
        return _scanned_url
    }
    
    var objects: Dictionary<String, AnyObject> {
        return _objects
    }
    
    func setup(user userKey: String, with userData: Dictionary<String, AnyObject>) {
        print(#function)
        
        self._uid = userKey
        
        if let name = userData["name"] as? String { _name = name }
        if let companyName = userData["company_name"] as? String { _companyName = companyName }
        if let qrUrl = userData["qr_url"] as? String { _qrUrl = qrUrl }
        if let scanned_url = userData["scanned_url"] as? String { _scanned_url = scanned_url }
        if let objects = userData["scanned"] as? Dictionary<String, AnyObject> { _objects = objects }
    }
    
    func update(_ address: [String : String]) {
        if !address.isEmpty { self._address = address }
    }
    
    func update(_ number: Any) {
        self._numbers.append(number as! String)
    }
    
    func update(_ uid: String) {
        self._objects.updateValue("true" as AnyObject, forKey: uid)
    }
    
}
