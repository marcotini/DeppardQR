//
//  HomeDatasource.swift
//  QRMarks
//
//  Created by Harry Wright on 28/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class HomeDatasource: CollectionViewDatasource {
    
    required init(withCollectionView collectionView: UICollectionView) {
        super.init(withCollectionView: collectionView)
    }
    
    required init(withCollectionView collectionView: UICollectionView, _ objects: [Any]) {
        super.init(withCollectionView: collectionView, objects)
    }
    
    override func cellClasses() -> [CollectionViewCell.Type] {
        return [CollectionViewCell.self]
    }
    
    override func numberOfItems(in section: Int) -> Int {
        return objects?.count ?? 0
    }
    
    override func item(at indexPath: IndexPath) -> Any? {
        return objects?[indexPath.item]
    }
    
}
