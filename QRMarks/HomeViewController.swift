//
//  TesterVC.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

class HomeViewController: FIRCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        
        // Creation of a FIRDatasource reference and `init's` the datasource's collection view
        // Tells the datasource which reference to use
        datasource = HomeDatasource(collectionView!)
        
        // Tells the datasource to download its data, which also reloads the data once downloaded
        datasource?.download()
        
        collectionView?.refreshControl = refreshControl()
    }
}
