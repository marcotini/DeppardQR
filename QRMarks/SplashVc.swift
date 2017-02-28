//
//  File.swift
//  QRMarks
//
//  Created by Harry Wright on 17/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class SplashVC: UIViewController, DownloadManagerDelegate {
    
    let identi: [String] = ["toHome"]
    
    var downloader: DownloadManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloader = DownloadManager(nil, withFIRReference: DataService.Singleton.REF_USERS)
        downloader?.delegate = self
        downloader?.downloadFirebaseUserObjects()
    }
    
    func downloadManager(didDownload userData: Dictionary<String, AnyObject>, for uid: String) {
        User.main.setup(user: uid, with: userData)
        
        self.performSegue(withIdentifier: self.identi[0], sender: nil)
    }
}
