//
//  SearchNavigationController.swift
//  QRMarks
//
//  Created by Harry Wright on 13/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

typealias SearchDelegates = UISearchControllerDelegate & UISearchResultsUpdating & UISearchBarDelegate

class SearchNavigationController: UINavigationController {
    
    var searchController: UISearchController!
    
    var delegates: SearchDelegates? {
        didSet {
            print(#function)
            self.searchController.delegate = delegates
            self.searchController.searchResultsUpdater = delegates
            self.searchController.searchBar.delegate = delegates
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(#file, #function)
        
        self.navigationBar.barTintColor = UIColor(red: 6, green: 128, blue: 216)
        self.navigationBar.removeShadow()
        
        self.searchController = UISearchController(searchResultsController: nil)
        
        self.searchController.searchBar.tintColor = .white
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        
        self.navigationBar.topItem?.titleView = searchController.searchBar
//        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#file)

    }
}
