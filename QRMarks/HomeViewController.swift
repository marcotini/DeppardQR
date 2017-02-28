//
//  TesterVC.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

let colours: [UIColor] = [.yellow, .cyan, .blue, .orange, .green, .lightGray]

class HomeViewController: CollectionViewController, DownloadManagerDelegate {
    
    var searchController : UISearchController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        
        // Sets up the datasource and download Manager
        datasource = HomeDatasource(withCollectionView: self.collectionView!)
        datasource?.downloadManager = DownloadManager(withFIRReference: DataService.Singleton.REF_USERS)
        datasource?.downloadManager?.delegate = self
        datasource?.downloadManager?.queryByChild = "company_name"
        datasource?.downloadManager?.downloadFirebaseObjects()

        // Required calls to set up a search contoller and insert it inside UINavigationItem
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.searchBar.setImage(nil, for: .search, state: .normal)
        self.searchController.searchBar.tintColor = .white
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
        
        collectionView?.refreshControl = refreshControl()
    }
    
    // Delegate Function
    func downloadManager(didDownload objectData: Array<Any>) {
        datasource?.objects = objectData
    }
}

/**
 HomeViewController extension to hold the search bar delegates
 */
extension HomeViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        print(#function)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
    }
    
}
