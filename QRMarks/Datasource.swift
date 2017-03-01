//
//  Datasource.swift
//  QRTests
//
//  Created by Harry Wright on 28/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

/**
 Protocol to hold the the functions and varibles for the user, this allows the user to create their very own `CollectionViewDatasource` class if they so wish if they don't want the build in `init` calls and `didSet`s.
 
 This is extended bellow to set up the functions as optional and set them with default values, which show how they can be used also
 */
protocol Datasource: class {
    
    /// The `UICollectionView` that is stored inside either the `CollectionViewController` or with `UICollectionView`s inside normal `UIViewController`
    var collectionView: UICollectionView? { get set }
    
    /// Property of the `CollectionViewDelegate` to allow the class to send functions to the main `UICollectionView`
    var delegate: CollectionViewDelegate? { get set }
    
    ///
    var controller: CollectionViewController? { get set }
    
    ///
    var downloadManager: Downloadable? { get set }
    
    ///
    var objects: [Any]? { get set }
    
    ///
    var filteredObjects: [Any]? { get set }
    
    ///
    init(withCollectionView collectionView: UICollectionView)
    
    ///
    init(withCollectionView collectionView: UICollectionView, _ objects: [Any])
    
    ///
    func cellClasses() -> [CollectionViewCell.Type]
    
    ///
    func numberOfItems(in section: Int) -> Int
    
    ///
    func numberOfSections() -> Int
    
    ///
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
