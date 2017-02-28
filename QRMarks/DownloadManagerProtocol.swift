//
//  DownloadManager.swift
//  QRTests
//
//  Created by Harry Wright on 28/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

typealias Downloading = (_ post: Array<Any>) -> Void
typealias DownloadingUser = (_ uid: String, _ post: Dictionary<String, AnyObject>) -> Void

protocol DownloadManagerDelegate: class {
    func downloadManager(didDownload userData: Dictionary<String, AnyObject>, for uid: String)
    func downloadManager(didDownload objectData: Array<Any>)
    func downloadManager(didUpload isUploaded: Bool?)
}

extension DownloadManagerDelegate {
    func downloadManager(didDownload userData: Dictionary<String, AnyObject>, for uid: String) { }
    func downloadManager(didDownload objectData: Array<Any>) { }
    func downloadManager(didUpload isUploaded: Bool?) { }
}

protocol Downloadable: class {
    
    var objects: [Any] { get set }
    
    var datasource: Datasource? { get set }
    
    var delegate: DownloadManagerDelegate? { get set }
    
    var queryByChild: String? { get set }
    
    init?()
    
    func downloadFirebaseObjects()
    
    func downloadFirebaseObjects(completion: @escaping Downloading)
    
    func downloadFirebaseUserObjects(with uid: String?)
    
    func downloadFirebaseUserObjects(completion: @escaping DownloadingUser)
}

protocol Uploadable: class {
    
    func addNewObjects(with uid: String?, _ completion: @escaping (Void) -> Void)
    
}
