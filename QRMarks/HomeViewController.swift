//
//  TesterVC.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

// TODO: Look at why when collapsing it looks so strange
// TODO: Small UI Checks

class CellCalc {
    var cell: PostCell
    var object: Posts
    var numberOfSections: CGFloat?
    
    init(cell: PostCell, object: Posts) {
        self.cell = cell
        self.object = object
        
        self.numberOfSections = 0
    }
    
    func numberOf() -> Int {
        if !cell.containsAnyting { return 0 }
        
        if cell.containsAddress && cell.containsNumber {
            self.numberOfSections = 2
            return (object.address?.count)! + (object.numbers?.count)!
        } else if cell.containsNumber && !cell.containsAddress {
            self.numberOfSections = 1
            return (object.numbers?.count)!
        } else if !cell.containsNumber && cell.containsAddress {
            self.numberOfSections = 1
            return (object.address?.count)!
        }
        
        return 0
    }
    
    func size(_ noOfItems: Int) -> CGFloat {
        if numberOfSections == 0 { return 0 }
        
        let cellHeadSize: CGFloat = 70
        let paddingToTV: CGFloat = 10
        
        let headerSize: CGFloat = 43 * numberOfSections!
        let totalCellSize: CGFloat = (43 * CGFloat(noOfItems))
        let footerSize: CGFloat = 43 * numberOfSections!
        
        let calc = cellHeadSize + paddingToTV + headerSize + totalCellSize + footerSize
        print(calc)
        return calc
    }
}

class HomeViewController: FIRCollectionViewController {
    
    var isSelected: Bool = false
    
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
    
    // This will extened the cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSelected {
            isSelected = !isSelected
            
            collectionView.performBatchUpdates({ self.layout?.invalidateLayout() }, completion: nil)
        } else {
            selectedIndex = indexPath.row
            isSelected = true
            
            collectionView.performBatchUpdates({ self.layout?.invalidateLayout() }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = self.collectionView?.cellForItem(at: indexPath) as? PostCell
        
        if (((isSelected && indexPath.row == selectedIndex ) || _object.count == 1) && (cell?.containsAnyting)!) {
            let object = self._object[indexPath.row] as? Posts
            cell?.isExtended = true
            
            let calculator = CellCalc(cell: cell!, object: object!)
            let numberOfCell = calculator.numberOf()
            return CGSize(width: view.bounds.width, height: calculator.size(numberOfCell))
        }
        
        cell?.tableView.isHidden = true
        cell?.isExtended = false
        
        return CGSize(width: view.bounds.width, height: 70)
    }
}
