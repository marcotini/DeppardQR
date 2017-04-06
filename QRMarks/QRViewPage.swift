//
//  QRViewPage.swift

//  QRMarks
//
//  Created by Harry Wright on 11/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class QRViewPage: UIViewController {

    @IBOutlet weak var QRCodeView: QRCode!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = User.main.uid else { return }
        self.QRCodeView = QRCode(withMessage: createUrl(uid), correctionLevel: .H)
        userName.text = User.main.name
        companyName.text = User.main.companyName
        
        self.navigationItem.title = User.main.name
    }
    
    // TEST BUTTON
    @IBAction func buttonPressed(_ sender: Any) {
        AuthManager.signOut()
        dismiss(animated: true, completion: nil)
    }
    
}
