//
//  File.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import Foundation

/// Class that subclasses User to create the Posts
class Posts: User {
    
    override init() {
        raise(init: "init(_:dict:)")
    }
    
    init(_ key: String?, dict: Dictionary<String, AnyObject>) {
        super.init()
        
        print(#function)
        
        _uid = key
        
        if let name = dict["name"] as? String { _name = name }
        
        if let companyName = dict["company_name"] as? String {
            _companyName = companyName
        } else {
            _companyName = "null"
        }
        
        if let address = dict["address"] as? Dictionary<String, String> { _address = address }
        
        if let number = dict["numbers"] as? Dictionary<String, String> {
            for (_, value) in number {
                _numbers.append(value)
            }
        }
    }
    
}
