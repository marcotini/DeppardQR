//
//  TesterVC.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class TesterDatasource: FIRDatasource {
    
    var words: [String] = []
    
    override init(_ view: UICollectionView) {
        super.init(view)
        
        let downloaded = Downloader(withFIRReference: DataService.sharedInstance.REF_USERS)
        self.downloader = downloaded
    }
    
    override func download() {
//        downloader?.downloadUserData({ (uid, dict) in
//            User.main.setup(user: uid, with: dict)
//            self.words.append(User.main.name)
//            self.words.append(User.main.companyName)
//            self.words.append(User.main.qrUrl)
//
//            self.reloadUI()
//        })
        
        downloader?.downloadPostData(completion: { (arr) in
            for item in arr {
                let post = item as? Posts
                print(post?.uid)
                print(createUrl((post?.uid)!))
                self.words.append((post?.uid)!)
            }
            
            self.reloadUI()
        })
    }
    
    override func cellClasses() -> [FIRCell.Type] {
        return [TestCell.self]
    }
    
    override func numberOfItems(in section: Int) -> Int {
        return words.count
    }
    
    override func item(at indexPath: IndexPath) -> Any? {
        return words[indexPath.item]
    }
}

class Tester: FIRCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creation of a FIRDatasource reference and `init's` the datasource's collection view
        let testData = TesterDatasource(collectionView!)
        
        // Tells the datasource which reference to use
        datasource = testData
        
        // Tells the datasource to download its data and also reloads the data once downloaded
        datasource?.download()
        
    }
    
}
