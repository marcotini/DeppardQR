//
//  Object.swift
//  QRMarks
//
//  Created by Harry Wright on 08/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import Foundation

class TimeObject: NSObject {
    
    private(set) var time: NSDate
    
    private(set) var timeText: String
    
    init(withTime time: NSDate) {
        print(#function)
        self.time = time
        self.timeText = "Last updated: \(time)"
    }
    
    func update(time: NSDate) {
        print(#function)
        self.time = time
        self.timeText = "Last updated: \(time)"
    }
    
}
