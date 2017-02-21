//
//  Test Cell.swift
//  QRMarks
//
//  Created by Harry Wright on 16/02/2017.
//  Copyright © 2017 Off Piste. All rights reserved.
//

import UIKit

typealias dict = (key: String, value: String)

class PostCell: CardCell, UITableViewDataSource, UITableViewDelegate {
    
    var _post: Posts! {
        didSet {
            defer {
                UIUpdate()
            }
            
            if let dict = _post.address {
                for (key, value) in  dict {
                    sectionOneKeyArr.append(key)
                    sectionOneDataArr.append(value)
                    
                    arrayKey.append(sectionOneKeyArr)
                    containsAddress = true
                    containsAnyting = true
                }
            } else {
                sectionOneKeyArr.append("loading...")
                sectionOneDataArr.append("loading...")
                
                arrayKey.append(sectionOneKeyArr)
                containsAddress = false
            }
            
            if let numbersArr = _post.numbers {
                for number in numbersArr {
                    //
                    
                    containsNumber = true
                    containsAnyting = true
                }
            } else {
                //
                
                containsNumber = false
            }
        }
    }
    
    var containsAnyting: Bool = false
    var containsAddress: Bool = false
    var containsNumber: Bool = false
    var arrayKey = [[String?]]()
    var sectionOneKeyArr = [String?]()
    var sectionOneDataArr = [String?]()
    
    override var isExtended: Bool? {
        didSet {
            if isExtended == true {
                tableView.isHidden = false
                
                tableView.allowsSelection = false
                tableView.allowsMultipleSelection = false
                
                tableView.reloadData()
            } else {
                tableView.isHidden = true
                
                tableView.allowsSelection = false
                tableView.allowsMultipleSelection = false
            }
        }
    }
    
    override var datasourceItem: Any? {
        willSet {
            sectionOneKeyArr.removeAll()
            sectionOneDataArr.removeAll()
        }
        didSet {
            if let item = datasourceItem as? Posts {
                _post = item
            } else {
                print(datasourceItem.debugDescription)
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(tableView)
        
        companyLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 8, rightConstant: 10, widthConstant: 0, heightConstant: 25)
        
        nameLabel.anchor(companyLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 25)
        
        tableView.anchor(nameLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func UIUpdate() {
        super.UIUpdate()
        
        nameLabel.text = _post?.name ?? nameLabel.text
        companyLabel.text = _post.companyName ?? companyLabel.text
        
    }
    
    // MARK: UI Creation
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "loading..."
//        label.backgroundColor = .green
        
        return label
    }()
    
    let companyLabel : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
//        label.backgroundColor = .blue
        label.text = "loading..."
        
        return label
    }()
    
    let tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        tv.backgroundColor = .white
        tv.allowsSelection = false
        tv.isHidden = true
        
        return tv
    }()
    
    /***********************************************************
     *                                                         *
     *                 Table View Functions                    *
     *                                                         *
     ***********************************************************/
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if containsAddress && containsNumber {
            return 2
        } else if (containsNumber ⊕ containsAddress) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(arrayKey.count)
        
        return sectionOneDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value2, reuseIdentifier: "mainCell")
        
        let mainHeader = sectionOneKeyArr[indexPath.row] ?? "null"
        let detail = sectionOneDataArr[indexPath.row] ?? "null"
        
        cell.textLabel?.text = mainHeader.capitalized
        cell.detailTextLabel?.text = detail
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Address"
        case 1: return "Phone Number"
        default: return "\(section)"
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0: return "To Maps"
        case 1: return "Call"
        default: return "\(section)"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
