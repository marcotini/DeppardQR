//
//  FIRCollectionViewController.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class FIRCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    /// Activity Indicator View that can be set anywhere to show information been downloaded
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .black
        return aiv
    }()
    
    /// Var to hold the datasource that the VC will use in code
    var datasource: FIRDatasource? {
        didSet {
            if let cellClasses = datasource?.cellClasses() {
                for cellClass in cellClasses {
                    collectionView?.register(cellClass, for: cellClass.string)
                }
            }
            
            collectionView?.reloadData()
        }
    }
    
    /// Var to hold UICollectionViewFlowLayout
    /// 
    /// May be used, may not be used, undecided...
    var layout: UICollectionViewFlowLayout? {
        get {
            return collectionViewLayout as? UICollectionViewFlowLayout
        }
    }
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(defaultCell.self)
    }
    
    func refreshControl() -> UIRefreshControl {
        let rc = UIRefreshControl()
        rc.tintColor = .lightGray
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }
    
    func handleRefresh() {
        datasource?.download()
        
        collectionView?.refreshControl?.endRefreshing()
    }

}

// MARK: - UICollectionViewDataSource

extension FIRCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource?.numberOfSections() ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfItems(in: section) ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FIRCell
        
        if let cls = datasource?.cellClass(indexPath) {
            // Not used
            
            cell = collectionView.dequeue(reuseCell: cls, for: indexPath) as! FIRCell
        } else if let cls = datasource?.cellClasses().first {
            // Sets the cell if only cell inside cellClasses()
            
            cell = collectionView.dequeue(reuseCell: cls, for: indexPath) as! FIRCell
        } else if let cellClasses = datasource?.cellClasses(), cellClasses.count > indexPath.section {
            // Sets the cell using the indexPath to return the cell class if mutiple cells used
            
            let cls = cellClasses[indexPath.section]
            cell = collectionView.dequeue(reuseCell: cls, for: indexPath) as! FIRCell
        } else {
            // If no cells use defaults
            
            cell = collectionView.dequeue(reuseCell: defaultCell.self, for: indexPath) as! FIRCell
        }
    
        // Sets the the data for the cell
        cell.controller = self
        cell.datasourceItem = datasource?.item(at: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}
