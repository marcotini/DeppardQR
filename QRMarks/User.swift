//
//  User.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import Foundation

class User {
    internal var _uid: String!
    private var _name: String!
    private var _companyName: String!
    private var _address: [String : String]!
    private var _qrUrl: String!
    private var _numbers: [String]! = []
    
    static let main = User()
    static let viewed = User()
    
    var uid: String {
        return _uid
    }
    
    var name: String {
        return _name
    }
    
    var companyName: String {
        return _companyName
    }
    
    var address: [String : String] {
        return _address
    }
    
    var qrUrl: String {
        return _qrUrl
    }
    
    var numbers: [String] {
        return _numbers
    }
    
    func setup(user userKey: String, with userData: Dictionary<String, AnyObject>) {
        NSLog("FUCK: Starting user setup")
        
        self._uid = userKey
        
        if let name = userData["name"] as? String { _name = name }
        if let companyName = userData["company_name"] as? String { _companyName = companyName }
        if let qrUrl = userData["qr_url"] as? String { _qrUrl = qrUrl }
        
        print(_name, _uid, _companyName, _qrUrl)
        NSLog("FUCK: Finished")
    }
    
    func update(_ address: [String : String]) {
        if !address.isEmpty { self._address = address }
    }
    
    func update(_ number: Any) {
        self._numbers.append(number as! String)
    }
    
}
