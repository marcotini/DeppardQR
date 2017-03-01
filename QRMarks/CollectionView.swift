//
//  CollectionView.swift
//  QRMarks
//
//  Created by Harry Wright on 01/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

// TODO: Test

class CollectionView: UICollectionView {
    
    ///
    var collectionViewDatasource: Datasource?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension CollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewDatasource?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDatasource?.numberOfItems(in: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        
        if let cls = collectionViewDatasource?.cellClasses().first {
            let cell = collectionView.deqeueCell(with: cls.reuseId, for: indexPath)
            cell?.backgroundColor = colours[indexPath.row]
            cell?.datasourceItem = collectionViewDatasource?.item(at: indexPath)
            return cell!
        } else if let cellClasses = collectionViewDatasource?.cellClasses(),
            cellClasses.count > indexPath.section {
            let cls = cellClasses[indexPath.section]
            
            let cell = collectionView.deqeueCell(with: cls.reuseId, for: indexPath)
            cell?.backgroundColor = colours[indexPath.row]
            cell?.datasourceItem = collectionViewDatasource?.item(at: indexPath)
            return cell!
        }
        
        return UICollectionViewCell()

    }
    
}
