//
//  FIRDatasource.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import Firebase

@objc protocol Datasource {
    @objc optional func downloadData(_ completion: @escaping (Void) -> Void)
    @objc optional func prepareUI()
}

class FIRDatasource: Datasource {
    
    /// A NSCache to hold `objects` so less download needed
    static var cache: NSCache<NSString, AnyObject> = NSCache()
    
    /// Var to hold the downloaded objects in class form, eg: Text Messages, Blog posts
    public var objects: [Any]?
    
    /// Var to hold the collection view been worked on, this allows for the datasource to reload data without a call inside the VC
    public var collectionView: UICollectionView?
    
    /// Var to hold the downloaded for the datacource
    public var downloader: Downloader?
    
    /// Init that will raise exception if used
    init() {
        raiseInit("(init(_:)")
    }
    
    /// Init that sets the var collectionView whe setup via super.init(view) in its overide
    @objc init(_ view: UICollectionView) {
        self.collectionView = view
    }
    
    // Keeping due to possability of finding a use for this method
    @available(*, unavailable, message: "Please use `download()` instead")
    func downloadData(_ completion: @escaping (Void) -> Void) { }
    
    @available(*, unavailable, message: "Please use `download()` and prepare UI changes in the completion handler of Downloader function")
    func prepareUI() { }
    
    /// Function to be overwitten to let the user download data and set it
    @available(iOS 10, *)
    func download() { }
    
    /// Function to reload the Collection View Data, may be overwritten if needs be eg. array to be nulled or maybe no data to be reloaded due to canceled calls
    func reloadUI() {
        collectionView?.reloadData()
    }
    
    /// Function to hold all the FIRCells been used by the datasource
    func cellClasses() -> [FIRCell.Type] {
        return []
    }
    
    /// This tells the collection view which cell is used what indexPath.section
    open func cellClass(_ indexPath: IndexPath) -> FIRCell.Type? {
        return nil
    }
    
    /// Neather looking `func collectionView(_:, numberOfItemsInSection:) -> Int`, works the same
    func numberOfItems(in section: Int) -> Int {
        return objects?.count ?? 0
    }
    
    /// Neater looking `func collectionView(_:numberOfSections:) -> Int call`, works the same
    func numberOfSections() -> Int {
        return 1
    }
    
    /// Tells the cell what its object is via the index path input
    open func item(at indexPath: IndexPath) -> Any? {
        return objects?[indexPath.item]
    }
}
