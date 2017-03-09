//
//  TesterVC.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import HWCollectionView

class HomeViewController: HWCollectionViewController, DownloadManagerDelegate {
    
    let kCellHeight: CGFloat = 80.0
    let kItemSpace: CGFloat = -20.0
    var searchController: UISearchController!
    var date: TimeObject!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        
        date = TimeObject(withTime: NSDate())
        
        // Sets up the datasource and download Manager
        datasource = HomeDatasource(withCollectionView: self.collectionView!)
        datasource?.controller = self
        
        // Sets up the datasources download manager and downloads the firebase objects
        datasource?.downloadManager = DownloadManager(withFIRReference: DataService.Singleton.REF_USERS)
        datasource?.downloadManager?.delegate = self
        datasource?.downloadManager?.queryByChild = "company_name"

        // Required calls to set up a search contoller and insert it inside UINavigationItem
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.tintColor = .white
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
        
        collectionView?.refreshControl = refreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        
        datasource?.downloadManager?.downloadFirebaseObjects()
    }
    
    // Delegate Function
    func downloadManager(didDownload objectData: Array<Any>) {
        print(#function)
        self.collectionView?.refreshControl?.attributedTitle = NSAttributedString(string: date.timeText)
        datasource?.objects = objectData
        
        if (self.collectionView?.refreshControl?.isRefreshing)! {
            self.date.update(time: NSDate())
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
    override func handleRefresh() {
        datasource?.downloadManager?.downloadFirebaseObjects()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(#function)
        
        return CGSize(width: view.bounds.width, height: kCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kItemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}

/**
 This is overridden due to containerView being a new item that was added in PostCell and that is the new background for the cell
 
 May Change Post class to hold the hex string for the cell so that it can be set in the post cell without overriding the cellForItemAt
 */
extension HomeViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        
        guard let cls = datasource?.cellClasses().first else { return UICollectionViewCell() }
        let cell = collectionView.deqeueCell(with: cls.reuseId, for: indexPath) as! PostCell
        
        cell.containerView.backgroundColor = datasource?.backgroundColorArray[indexPath.row]
        cell.datasourceItem = datasource?.item(at: indexPath)
        
        return cell
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
            searchBar.setShowsCancelButton(false, animated: true)
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
        Analytics.logSearch(searchBar.text!, byUser: User.main)
        
        searchBar.endEditing(true)
        view.endEditing(true)
    }
    
}
