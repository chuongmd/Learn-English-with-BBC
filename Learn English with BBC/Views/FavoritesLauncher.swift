//
//  FavoritesLauncher.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//

import Foundation
import UIKit

class FavoritesLauncher: NSObject, UITableViewDelegate, UITableViewDataSource
{
    
    //MARK:- Biến, hằng khai báo
    let cellId = "CellId"
    var mainViewController: MainViewController?
    var favoritesList = [Object]()
    var isConnectedFavorites: Bool!
    
    let moreView = UIView()
    let tableView: UITableView =
    {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 12
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    let nameLabelView: UILabel =
    {
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        nameLabel.text = "Favorites List"
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = UIColor.white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return nameLabel
    }()
    
    //MARK:- Các hàm chức năng
    
    // Hiện danh sách yêu thích
    func showFavorites()
    {
        if let window = UIApplication.shared.keyWindow
        {
            moreView.frame = window.frame
            moreView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            moreView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissFavorites)))
            
            favoritesList = Object.getFavoriteObjects()
            window.addSubview(moreView)
            window.addSubview(tableView)
            tableView.reloadData()
            
            let x = window.frame.width
            let y = (window.frame.height) / 2
            let width: CGFloat = window.frame.width - 48
            let heightIsEmpty: CGFloat = favoritesList.count == 0 ? 50 : 0
            let heightTest = CGFloat(self.favoritesList.count * 50) + nameLabelView.frame.height + heightIsEmpty
            
            
            tableView.frame = CGRect(x: x, y: y, width: 0, height: 0)
            moreView.alpha = 0
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations:
                {
                self.moreView.alpha = 1
                self.tableView.frame = CGRect(x: 24 , y: (window.frame.height - heightTest) / 2, width: width, height: heightTest)
                }, completion: nil)
            
            // Thiết lập cử chỉ vuốt để ẩn / hiện menu Settings
            let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightGesture))
            swipeRightGestureRecognizer.direction = .right
            swipeRightGestureRecognizer.delegate = window as? UIGestureRecognizerDelegate
            window.addGestureRecognizer(swipeRightGestureRecognizer)
        }
    }
    @objc func handleDismissFavorites()
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
            {
            self.moreView.alpha = 0
            if let window = UIApplication.shared.keyWindow
                {
                    self.tableView.frame = CGRect(x: window.frame.width, y: window.frame.height / 2, width: 0, height: 0)
                }
            }, completion: nil)
    }
    @objc func handleDismissClickOnFavorites(indexSelected: Int ,objects: [Object])
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
            {
            self.moreView.alpha = 0
            if let window = UIApplication.shared.keyWindow
                {
                    self.tableView.frame = CGRect(x: window.frame.width, y: window.frame.height / 2, width: 0, height: 0)
                }
            }, completion:
            { (_) in
            guard let mainViewController = self.mainViewController else { return }
            mainViewController.showDetailViewControllerForFavorites(indexSelected: indexSelected, objects: objects)
            })
    }
    
    //Hàm vuốt hiện favorites
    @objc func swipeRightGesture()
    {
        print("Doing swipe right in menu favorites")
        handleDismissFavorites()
    }
    
    //MARK:- Các hàm callBack của collectionView
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    { return nameLabelView }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    { return 50 }
    
    func numberOfSections(in tableView: UITableView) -> Int
    { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if favoritesList.count == 0
        { return 1 }
        return favoritesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if favoritesList.count == 0
        {
            cell.textLabel?.text = "Danh sách trống !"
            cell.imageView?.image = UIImage(named: "")
        } else
        {
            let favorite = favoritesList[indexPath.row]
            cell.textLabel?.text = favorite.title
            
            let cellImageLayer: CALayer?  = cell.imageView?.layer
            cellImageLayer!.cornerRadius = 25
            cellImageLayer!.masksToBounds = true
            cell.imageView?.contentMode = .topLeft
            cell.imageView?.loadImageCacheWithUrlString(urlString: favorite.urlMedia!, imageSize: CGSize(width: 50, height: 50))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    { return 50 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let indexSelected = tableView.indexPathForSelectedRow?.row else { return }
        if isConnectedFavorites
        {
            handleDismissClickOnFavorites(indexSelected: indexSelected, objects: favoritesList)
        } else
        {
            handleDismissFavorites()
            AlertView.showAlert(view: mainViewController!, title: "Warning !", message: "Không có kết nối mạng. Vui lòng quay lại sau !")
        }
    }
    
    //MARK:- Hàm khởi tạo của đối tượng SettingsLauncher
    override init()
    {
        super.init()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
}

