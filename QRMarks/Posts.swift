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
        raiseInit("init(_:dict:)")
    }
    
    init(_ key: String?, dict: Dictionary<String, AnyObject>) {
        super.init()
        
        _uid = key
        
        if let name = dict["name"] as? String { _name = name }
        if let companyName = dict["company_name"] as? String { _companyName = companyName }
        if let qrUrl = dict["qr_url"] as? String { _qrUrl = qrUrl }
        
        NSLog("FUCK: Finished")
    }
    
}
