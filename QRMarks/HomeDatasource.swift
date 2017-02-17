//
//  HomeDatasource.swift
//  QRMarks
//
//  Created by Harry Wright on 17/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class HomeDatasource: FIRDatasource {
    
    var posts: [Posts] = []
    
    override init(_ view: UICollectionView) {
        super.init(view)
        
        let downloaded = Downloader(withFIRReference: DataService.sharedInstance.REF_USERS)
        self.downloader = downloaded
    }
    
    override func download() {
        downloader?.downloadPostData(completion: { (arr) in
            self.posts = arr as! [Posts]
            
            self.reloadUI()
        })
    }
    
    override func cellClasses() -> [FIRCell.Type] {
        return [PostCell.self]
    }
    
    override func numberOfItems(in section: Int) -> Int {
        return posts.count
    }
    
    override func item(at indexPath: IndexPath) -> Any? {
        return posts[indexPath.item]
    }
}
