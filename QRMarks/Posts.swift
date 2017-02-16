//
//  File.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import Foundation

class Posts: User {
    
    init(_ key: String?, dict: Dictionary<String, AnyObject>) {
        super.init()
        
        self._uid = key
    }
    
}
