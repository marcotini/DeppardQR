//
//  File.swift
//  QRMarks
//
//  Created by Harry Wright on 17/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    let identi: [String] = ["toHome"]
    
    var downloader: Downloader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloader = Downloader(withFIRReference: DataService.sharedInstance.REF_USERS)
        
        downloader?.downloadUserData { (uid, dict) in
            User.main.setup(user: uid, with: dict)
            
            self.downloader?.items = User.main.objects
            self.performSegue(withIdentifier: self.identi[0], sender: nil)
        }
    }
}
