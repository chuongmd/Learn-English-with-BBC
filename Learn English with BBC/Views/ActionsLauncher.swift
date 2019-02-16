//
//  ActionsLauncher.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//

import Foundation
import UIKit

class ActionsLauncher: NSObject, UITableViewDelegate, UITableViewDataSource
{
    
    //MARK:- Biến, hằng khởi tạo
    var favoritesListAction = [Object]()
    var dataListObjectAction = [Object]()
    var favoriteObject: Object?
    let cellId = "CellId"
    var indexCurrent: Int?
    var detailViewController: DetailViewController?
    
    let backgroundView = UIView()
    let tableView: UITableView =
    {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 12
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    let containersView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    let addFavoriteButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let dividerLineView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameHeaderView: UILabel =
    {
        let nameHeader = UILabel()
        nameHeader.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        nameHeader.text = "Favorites"
        nameHeader.textAlignment = .center
        nameHeader.backgroundColor = UIColor.white
        nameHeader.font = UIFont.boldSystemFont(ofSize: 20)
        return nameHeader
    }()
    
    //MARK:- Các hàm chức năng
    func showActions()
    {
        if let window = UIApplication.shared.keyWindow
        {
            backgroundView.frame = window.frame
            backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            backgroundView.alpha = 0
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(backgroundView)
            
            // Configuration tableView
            let x: CGFloat = 12
            let y: CGFloat = window.frame.height
            let widthTable: CGFloat = window.frame.width - 2 * x
            let heightTable: CGFloat = (window.frame.height) * 2 / 5
            tableView.frame = CGRect(x: x, y: y, width: widthTable, height: heightTable)
            window.addSubview(tableView)
            
            // Configuration collectionView
            let widthCollection: CGFloat = widthTable
            let heightCollection: CGFloat = 100
            containersView.frame = CGRect(x: x, y: y + x, width: widthCollection, height: heightCollection)
            window.addSubview(containersView)
            
            // Cài đặt trạng thái của addFavoriteButton
            if (self.favoriteObject?.isFavorited)!
            {
                print("Phan tu da co trong danh sach Favorite")
                addFavoriteButton.isEnabled = false
                addFavoriteButton.setTitle("Add to Favorites", for: .disabled)
                addFavoriteButton.setTitleColor(UIColor.gray, for: .disabled)
            } else
            {
                addFavoriteButton.isEnabled = true
                addFavoriteButton.setTitle("Add to Favorites", for: .normal)
                addFavoriteButton.setTitleColor(UIColor.blue, for: .normal)
            }
            
            containersView.addSubview(addFavoriteButton)
            containersView.addSubview(dividerLineView)
            containersView.addSubview(cancelButton)
            cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
            addFavoriteButton.addTarget(self, action: #selector(handleAddFavorite), for: .touchUpInside)
            containersView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": addFavoriteButton]))
            containersView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": dividerLineView]))
            containersView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": cancelButton]))
            containersView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(50)][v1(1)][v2]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": addFavoriteButton, "v1": dividerLineView, "v2": cancelButton]))
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
                {
                self.backgroundView.alpha = 1
                
                self.containersView.frame = CGRect(x: x, y: y - heightCollection - x , width: self.containersView.frame.width, height: self.containersView.frame.height)
                
                self.tableView.frame = CGRect(x: x, y: y - heightTable - x - heightCollection - x, width: self.tableView.frame.width, height: self.tableView.frame.height)
                
                }, completion: nil)
        }
    }
    
    @objc func handleDismiss()
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
        {
            self.backgroundView.alpha = 0
            if let window = UIApplication.shared.keyWindow
            {
                self.tableView.frame = CGRect(x: 0, y: window.frame.height, width: self.tableView.frame.width, height: self.tableView.frame.height)
                self.containersView.frame = CGRect(x: 0, y: window.frame.height, width: self.containersView.frame.width, height: self.containersView.frame.height)
            }
        }, completion: nil)
    }
    
    @objc func handleCancel()
    {
        print("This is cancel button")
        self.handleDismiss()
    }
    
    @objc func handleAddFavorite()
    {
        guard let favoriteObject = favoriteObject,
              let indexCurrent = indexCurrent else { return }
        favoriteObject.isFavorited = true
        Object.updateIsFavoritedObject(favoriteObject: favoriteObject, isNewValueFavorited: favoriteObject.isFavorited)
        favoritesListAction.append(favoriteObject)
        detailViewController?.favoritesListDetail = favoritesListAction
        print((detailViewController?.favoritesListDetail.count)!)
        detailViewController?.setupNavBarTitle(indexCurrent)
        tableView.reloadData()
        handleDismiss()
    }
    
    //MARK:- Hàm khởi tạo của đối tượng ActionsLauncher
    override init()
    {
        super.init()
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        detailViewController?.actionsLauncher = self
    }
    
    //MARK:- Các hàm callback của tableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    { return nameHeaderView }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    { return 50 }
    
    func numberOfSections(in tableView: UITableView) -> Int
    { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    { return favoritesListAction.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let favoriteObject = favoritesListAction[indexPath.row]
        cell.textLabel?.text = favoriteObject.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        let cellImageLayer: CALayer?  = cell.imageView?.layer
        cellImageLayer!.cornerRadius = 25
        cellImageLayer!.masksToBounds = true
        cell.imageView?.contentMode = .topLeft
        cell.imageView?.loadImageCacheWithUrlString(urlString: favoriteObject.urlMedia!, imageSize: CGSize(width: 50, height: 50))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    { return 50 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let indexPathFavorited = tableView.indexPathForSelectedRow?.row,
              let detailViewController = detailViewController  else { return }
        detailViewController.objectCurrent = favoritesListAction[indexPathFavorited]
        detailViewController.indexCurrent = indexPathFavorited
        detailViewController.dataListObjectDetail = favoritesListAction
        detailViewController.setupNavBarTitle(indexPathFavorited)
        detailViewController.loadDetail(indexPathFavorited)
        tableView.deselectRow(at: indexPath, animated: true)
        handleDismiss()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    { return true }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == UITableViewCell.EditingStyle.delete)
        {
            let objectFavorited = favoritesListAction[indexPath.row]
            objectFavorited.isFavorited = false
            Object.updateIsFavoritedObject(favoriteObject: objectFavorited, isNewValueFavorited: objectFavorited.isFavorited)
            
            // Reload lại navigationBar để setup title khi xóa object khỏi danh sách favorite
            var indexForReloadNavBar: Int!
            for (index, object) in dataListObjectAction.enumerated()
            {
                if favoritesListAction[indexPath.row].title! == object.title!
                {
                    indexForReloadNavBar = index
                    if indexForReloadNavBar == indexCurrent!
                    {
                        detailViewController?.setupNavBarTitle(indexForReloadNavBar)
                    }
                }
            }
            favoritesListAction.remove(at: indexPath.row)
            detailViewController?.favoritesListDetail = favoritesListAction
            tableView.reloadData()
        }
    }
}
