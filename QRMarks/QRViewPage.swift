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
    
    let datasource = qrViewDatasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        datasource.controller = self
        datasource.imageView = qrView
        datasource.downloadData(dict as Dictionary<String, AnyObject>)
    }
    
    func reloadUI() {
        qrView.image = datasource.image
        userName.text = User.main.name
        companyName.text = User.main.companyName
    }
}
