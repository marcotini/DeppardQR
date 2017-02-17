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
        // Do any additional setup after loading the view, typically from a nib.
        
        datasource = qrViewDatasource()
        datasource?.controller = self
        datasource?.imageView = qrView
        datasource?.prepareUI()
    }
    
    func reloadUI() {
        qrView.image = datasource?.image
        userName.text = User.main.name
        companyName.text = User.main.companyName
        
        self.navigationItem.title = User.main.name
    }
}
