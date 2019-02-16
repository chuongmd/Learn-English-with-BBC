//
//  TableViewController.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController
{
    
    //MARK:- Biến, hằng khởi tạo
    //Biến cờ đánh dấu trạng thái kết nối mạng, true là đã kết nối, false là không được kết nối
    var isConnectedTable: Bool!
    
    //Mảng chứa Item trả về sau khi thực hiện việc tìm kiếm trên searchBar
    var searchObjectsTable = [Object]()
    
    //Biến cờ đánh dấu có đang search hay không
    var isSearchingTable: Bool = false
    
    // Biến cờ đánh dấu đang sắp xếp theo dạng nào
    var isSortedTable: Sorted!
    
    let cellId: String = "EnglishTableViewCell"
    
    //Biến chứa các phần tử được lưu trong Database
    var dataListObjectTable = [Object]()
    
    // Biến chứa các phần tử trong yêu thích trong CoreData
    var favoritesListTable = [Object]()
    
    //MARK:- Các hàm ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white
        tableView.register(EnglishTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    // Hàm chạy mỗi khi back lại view
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //MARK:- Các hàm callback của tableView
    override func numberOfSections(in tableView: UITableView) -> Int
    { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isSearchingTable
        { return searchObjectsTable.count }
        else
        { return dataListObjectTable.count }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //Khởi tạo cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EnglishTableViewCell
        func setupAppearanceCell()
        {
            cell.textLabelView.textColor = UIColor.black
            cell.textLabelView.font = UIFont.boldSystemFont(ofSize: 16)
            cell.textLabelView.numberOfLines = 2
            cell.textLabelView.lineBreakMode = .byWordWrapping
            cell.detailTextLabelView.font = UIFont.systemFont(ofSize: 13)
            cell.detailTextLabelView.textColor = UIColor.black
        }
        
        // Hàm Lấy dữ liệu gán vào dòng hiện tại
        func getDataForSort()
        {
            if isSearchingTable
            {
                let itemObj = searchObjectsTable[indexPath.row]
                let urlImage = itemObj.urlMedia
                setupAppearanceCell()
                cell.textLabelView.text = itemObj.title
                cell.detailTextLabelView.text = itemObj.descriptions
                
                // Kiểm tra xem Object hiện tại có phải là favorite object không
                cell.imageMediaView.layer.borderColor = itemObj.isFavorited ? UIColor.red.cgColor : UIColor.clear.cgColor
                cell.imageMediaView.layer.borderWidth = 2
                cell.imageMediaView.loadImageCacheWithUrlString(urlString: urlImage!, imageSize: CGSize(width: 70, height: 70))
            } else
            {
                let itemObj = dataListObjectTable[indexPath.row]
                setupAppearanceCell()
                cell.textLabelView.text = itemObj.title
                cell.detailTextLabelView.text = itemObj.descriptions
                
                // Kiểm tra xem Object hiện tại có phải là favorite object không
                cell.imageMediaView.layer.borderColor = itemObj.isFavorited ? UIColor.red.cgColor : UIColor.clear.cgColor
                cell.imageMediaView.layer.borderWidth = 2
                if let urlImage = itemObj.urlMedia
                { cell.imageMediaView.loadImageCacheWithUrlString(urlString: urlImage, imageSize: CGSize(width: 70, height: 70))}
            }
        }
        
        if isSortedTable == .sortByNumbericOrder
        {
            getDataForSort()
        }
        else if isSortedTable == .sortByOrder
        {
            getDataForSort()
        } else if isSortedTable == .sortReverseAlphabeticalOrder
        {
            getDataForSort()
        } else if isSortedTable == .sortByAlphabet
        {
            getDataForSort()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    { return 88 }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //MARK:- Xem lai NavigationController
        let detailViewController = DetailViewController()
        detailViewController.tableViewController = self
        let navController = UINavigationController(rootViewController: detailViewController)
        guard let indexSelected = tableView.indexPathForSelectedRow?.row else { return }
        
        func settingSortChangeValue()
        {
            if isSearchingTable
            {
                guard let titleSearch = searchObjectsTable[indexSelected].title else { return }
                print(indexSelected)
                dataListObjectTable = Object.getAllObject()
                for indexObject in dataListObjectTable.indices
                {
                    guard let titleObject = dataListObjectTable[indexObject].title  else { return }
                    if titleSearch == titleObject
                    {
                        print(indexObject)
                        detailViewController.indexCurrent = indexObject
                        detailViewController.dataListObjectDetail = dataListObjectTable
                        detailViewController.favoritesListDetail = Object.getFavoriteObjects()
                        if isConnectedTable
                        {
                            present(navController, animated: true, completion: nil)
                        } else
                        {
                            AlertView.showAlert(view: self, title: "Warning !", message: "Không có kết nối mạng. Vui lòng quay lại sau !")
                        }
                    }
                }
                
            } else
            {
                detailViewController.dataListObjectDetail = self.dataListObjectTable
                detailViewController.indexCurrent = indexSelected
                detailViewController.favoritesListDetail = Object.getFavoriteObjects()
                
                if isConnectedTable
                {
                    present(navController, animated: true, completion: nil)
                } else
                {
                    AlertView.showAlert(view: self, title: "Warning !", message: "Không có kết nối mạng. Vui lòng quay lại sau !")
                }
            }
        }
        
        if isSortedTable == .sortByNumbericOrder
        {
            settingSortChangeValue()
        } else if isSortedTable == .sortByOrder
        {
            settingSortChangeValue()
        } else if isSortedTable == .sortReverseAlphabeticalOrder
        {
            settingSortChangeValue()
        } else
        {
            settingSortChangeValue()
        }
    }
}



