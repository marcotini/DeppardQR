//
//  TesterVC.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import HWCollectionView

let backgroundColor = UIColor(white: 1.0, alpha: 0.9)

// HWCollectionView
class HomeViewController: HWCollectionViewController, NetworkManagerDelegate {
    
    var date: TimeObject!
    let kCellHeight: CGFloat = 80.0
    let kItemSpace: CGFloat = -20.0
    let kFirstItemTransform: CGFloat = 0.05
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 6, green: 128, blue: 216)
        
        collectionView?.backgroundView?.round(corners: [.topLeft, .topRight], radius: 12)
        collectionView?.backgroundColor = .clear
        
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl()
        } else {
            // Fallback on earlier versions
        }
        
        date = TimeObject(withTime: NSDate())
        
        // Sets up the datasource and download Manager
        datasource = HomeDatasource(withCollectionView: self.collectionView!)
        datasource?.controller = self
        
        // Sets up the datasources download manager and downloads the firebase objects
        datasource?.networkManager = DownloadManager(withFIRReference: DataService.Singleton.REF_USERS)
        datasource?.networkManager?.delegate = self
        datasource?.networkManager?.queryByChild = "company_name"
        
        let navController = self.navigationController as? SearchNavigationController
        navController?.delegates = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        
        datasource?.networkManager?.downloadObjects()
    }
    
    override func refreshOptions() {
        datasource?.networkManager?.downloadObjects()
    }
    
    func networkManager(_ networkManager: Networkable, didDownload objectData: Array<Any>) {
        print(#function)
        
        if #available(iOS 10.0, *) {
            self.collectionView?.refreshControl?.attributedTitle = NSAttributedString(string: date.timeText)
        } else {
            // Fallback on earlier versions
        }
        
        datasource?.objects = objectData
        
        if #available(iOS 10.0, *) {
            if (self.collectionView?.refreshControl?.isRefreshing)! {
                self.date.update(time: NSDate())
                self.collectionView?.refreshControl?.endRefreshing()
            }
        } else {
            // Fallback on earlier versions
        }
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
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        
        cell.cornerView.backgroundColor = datasource?.backgroundColorArray[indexPath.row]
        cell.datasourceItem = datasource?.item(at: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = datasource?.item(at: indexPath) as? Posts
        print(#function, object?.companyName ?? "Unknown")
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
                if let type = ($0 as! Posts) as Posts? {
                    let companyName = type.companyName?.lowercased() ?? "null"
                    let name = type.name?.lowercased() ?? "null"
                    
                    let text = searchBar.text?.lowercased()
                    return (companyName.contains(text!)) || (name.contains(text!))
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
