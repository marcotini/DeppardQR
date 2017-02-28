//
//  QRViewPage.swift

//  QRMarks
//
//  Created by Harry Wright on 11/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import FIFIlter

class QRViewPage: UIViewController, QRDelegate {

    @IBOutlet weak var qrView: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    // Why datasource you may ask, QR's may be created elsewhere in the program so geting ready...
    var datasource: QRDatasource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialises the datasource
        // Also Sets the datasource ImageView, this is needed for the QR creation
        datasource = qrViewDatasource(withImageView: qrView)
        
        // Connects the delegate for the datasource
        datasource?.controller = self
        
        // Tell the datasource to prepare the UI before it calls the reload UI
        datasource?.prepareUI()
    }
    
    func reloadUI(with image: UIImage) {
        qrView.image = image
        userName.text = User.main.name
        companyName.text = User.main.companyName
        
        self.navigationItem.title = User.main.name
    }
    
    // TEST BUTTON
    @IBAction func buttonPressed(_ sender: Any) {
        datasource?.upload(data: uid, to: DataService.Singleton.REF_USERS)
    }
    
}
