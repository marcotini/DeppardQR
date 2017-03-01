//
//  CollectionViewController.swift
//  QRTests
//
//  Created by Harry Wright on 28/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

public class CollectionViewController: UICollectionViewController {
    
    var datasource: Datasource?
    
    /// In the of chance of collection view being used with a search bar
    var isSearching: Bool = false
    
    /// Getter and Setter for the backgroundColor of the collection view
    var backgroundColor: UIColor {
        get {
            collectionView?.backgroundColor = .white
            return (collectionView?.backgroundColor)!
        }
        set {
            collectionView?.backgroundColor = newValue
        }
    }
    
    /// Getter for the collectionViewLayout
    var layout: UICollectionViewLayout? {
        get {
            return collectionViewLayout as UICollectionViewLayout
        }
    }
    
    // MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
    }
    
    // MARK: Basic UI
    
    /// Activity Indicator View that can be set anywhere to show information been downloaded
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .black
        return aiv
    }()
    
    
    // MARK: UIRefreshControl
    
    func refreshControl() -> UIRefreshControl {
        let rc = UIRefreshControl()
        rc.tintColor = .lightGray
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        return rc
    }
    
    /// Override to handle the refresh control target
    func handleRefresh() {
        collectionView?.refreshControl?.endRefreshing()
    }
}

/**
 Extension for Collection View Datasource
 */
extension CollectionViewController {
    
    // MARK: Collection View Functions
    
    override public func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(#function)
        
        return datasource?.numberOfSections() ?? 1
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        
        return datasource?.numberOfItems(in: section) ?? 0
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        
        if let cls = datasource?.cellClasses().first {
            let cell = collectionView.deqeueCell(with: cls.reuseId, for: indexPath)
            cell?.backgroundColor = colours[indexPath.row]
            cell?.datasourceItem = datasource?.item(at: indexPath)
            return cell!
        } else if let cellClasses = datasource?.cellClasses(), cellClasses.count > indexPath.section {
            let cls = cellClasses[indexPath.section]
            
            let cell = collectionView.deqeueCell(with: cls.reuseId, for: indexPath)
            cell?.backgroundColor = colours[indexPath.row]
            cell?.datasourceItem = datasource?.item(at: indexPath)
            return cell!
        }
        
        return UICollectionViewCell()
    }
    
}
