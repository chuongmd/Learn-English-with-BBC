//
//  CollectionViewController.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//

import UIKit
import CoreData


class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    //MARK:- Biến, hằng khởi tạo
    
    //Biến cờ đánh dấu trạng thái kết nối mạng, true là đã kết nối, false là không được kết nối
    var isConnectedCollection: Bool!
    
    //Mảng chứa Item trả về sau khi thực hiện việc tìm kiếm trên searchBar
    var searchObjectsCollection = [Object]()
    
    //Biến cờ đánh dấu có đang search hay không
    var searchingCollection: Bool = false
    
    var isSortCollection: Sorted!
    
    let cellId: String = "EnglishCollectionViewCell"
    
    //Biến chứa các phần tử được lưu trong Database
    var dataListObjectCollection = [Object]()
    
    // Biến chứa các phần tử trong yêu thích trong CoreData
    var favoritesListCollection = [Object]()
    
    //MARK:- Các thiết lập dữ liệu ban đầu
    //Thiết lập layout cho CollectionView
    func setupFlowLayout()
    {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }
    }
    //MARK:- Các hàm ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        collectionView.register(EnglishCollectionViewCell.self, forCellWithReuseIdentifier: "EnglishCollectionViewCell")
        setupFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }

    //MARK:- Các hàm CallBack của CollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if searchingCollection
        { return searchObjectsCollection.count }
        else
        { return dataListObjectCollection.count }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnglishCollectionViewCell", for: indexPath) as! EnglishCollectionViewCell

        //Lấy dữ liệu gán vào dòng hiện tại
        func getDataForSort()
        {
            if searchingCollection
            {
                let itemObj = searchObjectsCollection[indexPath.item]
                let urlImage = itemObj.urlMedia
                cell.textLabelView.text = itemObj.title
                cell.detailTextLabelView.text = itemObj.descriptions
                
                //Hàm kiểm tra object hiện tại có là favorite object không
                cell.contentView.layer.borderColor = itemObj.isFavorited ? UIColor.red.cgColor : UIColor.gray.cgColor
                cell.imageMediaView.loadImageCacheWithUrlString(urlString: urlImage!, imageSize: CGSize(width: 100, height: 100))
            } else
            {
                let itemObj = dataListObjectCollection[indexPath.item]
                let urlImage = itemObj.urlMedia
                cell.textLabelView.text = itemObj.title
                cell.detailTextLabelView.text = itemObj.descriptions
                
                //Hàm kiểm tra object hiện tại có là favorite object không
                cell.contentView.layer.borderColor = itemObj.isFavorited ? UIColor.red.cgColor : UIColor.gray.cgColor
                cell.imageMediaView.loadImageCacheWithUrlString(urlString: urlImage!, imageSize: CGSize(width: 100, height: 60))
            }
        }
        if isSortCollection == .sortByNumbericOrder
        {
            getDataForSort()
        } else if isSortCollection == .sortByOrder
        {
            getDataForSort()
        } else if isSortCollection == .sortByAlphabet
        {
           getDataForSort()
        } else if isSortCollection == .sortReverseAlphabeticalOrder
        {
            getDataForSort()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //MARK:- Xem lai NavigationController
        let detailViewController = DetailViewController()
        detailViewController.collectionViewController = self
        let navController = UINavigationController(rootViewController: detailViewController)
        guard let indexSelected = collectionView.indexPathsForSelectedItems?.first?.item else { return }
        
        func settingSortChangeValue()
        {
            if searchingCollection
            {
                guard let titleSearch = searchObjectsCollection[indexSelected].title else { return }
                dataListObjectCollection = Object.getAllObject()
                for indexObject in dataListObjectCollection.indices
                {
                    guard let titleObject = dataListObjectCollection[indexObject].title  else { return }
                    if titleSearch == titleObject
                    {
                        print(indexObject)
                        detailViewController.indexCurrent = indexObject
                        detailViewController.dataListObjectDetail = dataListObjectCollection
                        detailViewController.favoritesListDetail = Object.getFavoriteObjects()
                        if isConnectedCollection
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
                detailViewController.dataListObjectDetail = self.dataListObjectCollection
                detailViewController.indexCurrent = indexSelected
                detailViewController.favoritesListDetail = Object.getFavoriteObjects()
                if isConnectedCollection
                {
                    present(navController, animated: true, completion: nil)
                } else
                {
                    AlertView.showAlert(view: self, title: "Warning !", message: "Không có kết nối mạng. Vui lòng quay lại sau !")
                }
            }
        }
        if isSortCollection == .sortByNumbericOrder
        {
            settingSortChangeValue()
        } else if isSortCollection == .sortByOrder
        {
            settingSortChangeValue()
        } else if isSortCollection == .sortReverseAlphabeticalOrder
        {
            settingSortChangeValue()
        } else
        {
            settingSortChangeValue()
        }
    }
    
    //Thiết lập kích thước của một CollectionViewCell khi hiển thị trên màn hình: Width, Height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (UIScreen.main.bounds.size.width - 36) / 2, height: (UIScreen.main.bounds.size.width - 36) / 2)
    }
}


