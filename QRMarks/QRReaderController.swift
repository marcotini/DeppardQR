//
//  qrReaderController.swift
//  QRMarks
//
//  Created by Harry Wright on 13/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class QRReaderController: ReaderViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isAuthorized() {
            captureSession?.startRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if error != nil { createAlert((error?.localizedDescription)!); return }
    }
    
    // Just incase of an error
    func createAlert(_ error: String)  {
        let alert = UIAlertController(title: "Error With Camera", message: error, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Back To Home", style: .cancel) { (action) in
            self.segue()
        }
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    func segue() {
        tabBarController?.selectedIndex = 0
    }
}

