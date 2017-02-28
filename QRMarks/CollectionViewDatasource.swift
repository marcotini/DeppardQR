//
//  HWCollectionViewDatasource.swift
//  QRTests
//
//  Created by Harry Wright on 27/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class CollectionViewDatasource: NSObject, Datasource {
    
    // MARK: Properties
    
    var collectionView: UICollectionView?
    
    var downloadManager: Downloadable?
    
    public var objects: [Any]? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    weak var delegate: CollectionViewDelegate? {
        didSet {
            print(#function)
            guard delegate != nil else { return }
            delegate?.register?(self.cellClasses())
        }
    }
    
    // MARK: Initalisation
    
    @available(*, unavailable, message: "'init()' is not suported, please use 'init(withCollectionView:)' or 'init(withCollectionView:_:)' instead")
    override init() { }
    
    required init(withCollectionView collectionView: UICollectionView) {
        print(#function)
        
        self.collectionView = collectionView
    }
    
    required init(withCollectionView collectionView: UICollectionView, _ objects: [Any]) {
        print(#function)
        
        self.collectionView = collectionView
        self.objects = objects
    }
    
    // MARK: Collection View Datasource
    
    /// Needed to set the classes for the collection view
    func cellClasses() -> [CollectionViewCell.Type] {
        return [CollectionViewCell.self]
    }
    
    func numberOfItems(in section: Int) -> Int {
        print(#function)
        
        return (objects?.count)!
    }
    
    func item(at indexPath: IndexPath) -> Any? {
        print(#function)
        
        return objects?[indexPath.item]
    }
}

/**
 
 */
extension UICollectionView {
    func register(cellClass: CollectionViewCell.Type?) {
        print(#function)
        
        let cellName = cellClass?.reuseId
        self.register(cellClass, forCellWithReuseIdentifier: cellName!)
    }
    
    func deqeueCell(with reuse: String, for indexPath: IndexPath) -> CollectionViewCell? {
        let cell = self.dequeueReusableCell(withReuseIdentifier: reuse, for: indexPath) as? CollectionViewCell
        return cell
    }
}
