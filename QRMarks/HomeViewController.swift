//
//  TesterVC.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import HWCollectionView

class HomeViewController: CollectionViewController, DownloadManagerDelegate {
    
    var searchController: UISearchController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        print(#file)
        print(#function)
        
        collectionView?.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        
        // Sets up the datasource and download Manager
        datasource = HomeDatasource(withCollectionView: self.collectionView!)
        datasource?.controller = self
        
        // Sets up the datasources download manager and downloads the firebase objects
        datasource?.downloadManager = DownloadManager(withFIRReference: DataService.Singleton.REF_USERS)
        datasource?.downloadManager?.delegate = self
        datasource?.downloadManager?.queryByChild = "company_name"
        datasource?.downloadManager?.downloadFirebaseObjects()

        // Required calls to set up a search contoller and insert it inside UINavigationItem
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.tintColor = .white
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
        
        collectionView?.refreshControl = refreshControl()
    }
    
    // Delegate Function
    func downloadManager(didDownload objectData: Array<Any>) {
        print(#function)
        
        datasource?.objects = objectData
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(#function)
        
        return CGSize(width: view.frame.width, height: 70)
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
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            
            collectionView?.reloadData()
            searchBar.endEditing(true)
        } else {
            isSearching = true
            
            // Filter for the searchBar
            datasource?.filteredObjects = datasource?.objects?.filter({
                if let type = ($0 as! Posts).companyName?.lowercased() as String? {
                    let text = searchBar.text?.lowercased()
                    return (type.contains(text!))
                } else {
                    return false
                }
            })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
