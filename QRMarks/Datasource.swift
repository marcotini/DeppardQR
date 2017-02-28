//
//  Datasource.swift
//  QRTests
//
//  Created by Harry Wright on 28/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

protocol Datasource: class {
    
    var collectionView: UICollectionView? { get set }
    
    var delegate: CollectionViewDelegate? { get set }
    
    var downloadManager: Downloadable? { get set }
    
    var objects: [Any]? { get set }
    
    func cellClasses() -> [CollectionViewCell.Type]
    
    init(withCollectionView collectionView: UICollectionView)
    
    init(withCollectionView collectionView: UICollectionView, _ objects: [Any])
    
    func numberOfItems(in section: Int) -> Int
    
    func numberOfSections() -> Int
    
    func item(at indexPath: IndexPath) -> Any?
    
}

/**
 Extension of Datasource to optional the functions and set the default values for the functions
 */
extension Datasource where Self: CollectionViewDatasource {
    
    func numberOfItems(in section: Int) -> Int {
        print(#function)
        
        return objects?.count ?? 0
    }
    
    func numberOfSections() -> Int {
        print(#function)
        
        return 1
    }
    
    func item(at indexPath: IndexPath) -> Any? {
        print(#function)
        
        return objects?[indexPath.item]
    }
}
