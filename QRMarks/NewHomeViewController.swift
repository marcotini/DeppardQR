//
//  NewHomeViewController.swift
//  QRMarks
//
//  Created by Harry Wright on 09/03/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit
import HWCollectionView

class NewHomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: LocalCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#file)
        print(#function)
        
        
        collectionView.controller = self
        collectionView.collectionViewDatasource = HomeDatasource(withCollectionView: collectionView,
                                                                 objects: Array(repeating: 2, count: 100))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.reloadData()
    }
    
}

class LocalCollectionView: HWCollectionView, UICollectionViewDelegateFlowLayout {
    
    let kCellHeight: CGFloat = 100.0
    let kItemSpace: CGFloat = -20.0
    let kFirstItemTransform: CGFloat = 0.05
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(#function)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        
        guard let cls = collectionViewDatasource?.cellClasses().first else { return UICollectionViewCell() }
        let cell = collectionView.deqeueCell(with: cls.reuseId, for: indexPath) as! TestCell
        
        cell.cornerView.backgroundColor = collectionViewDatasource?.backgroundColorArray[indexPath.row]
        cell.datasourceItem = collectionViewDatasource?.item(at: indexPath)
        cell.configCell()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(#function)
        return CGSize(width: (controller?.view.bounds.width)!, height: kCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kItemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
