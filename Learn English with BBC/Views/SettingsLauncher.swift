//
//  SettingsLauncher.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//

import Foundation
import UIKit

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    //MARK:- Biến, hằng khai báo
    var mainViewController: MainViewController?
    let moreView = UIView()
    let collectionView: UICollectionView =
    {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "CellId"
    let headerId = "HeaderId"
    let settings: [Setting] =
    {
        return [Setting(name: .sortByNumbericOrder, imageName: "sort_by_numeric_order"),
                Setting(name: .sortByOrder, imageName: "sort_by_order"),
                Setting(name: .sortReverseAlphabeticalOrder, imageName: "sort_reverse_alphabetical_order"),
                Setting(name: .sortByAlphabet, imageName: "sort_by_alphabet"),
                Setting(name: .termPrivacy, imageName: "term_privacy"),
                Setting(name: .sendFeedback, imageName: "send_feedback"),
                Setting(name: .help, imageName: "help"),
                Setting(name: .cancel, imageName: "cancel")]
    }()
    
    //MARK:- Các hàm chức năng
    func showSettings()
    {
        if let window = UIApplication.shared.keyWindow
        {
            moreView.frame = window.frame
            moreView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            moreView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissSettings)))
            
            window.addSubview(moreView)
            window.addSubview(collectionView)
            
            collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: (window.frame.width) * 4 / 5, height: window.frame.height)
            moreView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
                {
                    self.moreView.alpha = 1
                    self.collectionView.frame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
            
            // Thiết lập cử chỉ vuốt để ẩn / hiện menu Settings
            let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftGesture))
            swipeLeftGestureRecognizer.direction = .left
            swipeLeftGestureRecognizer.delegate = window as? UIGestureRecognizerDelegate
            window.addGestureRecognizer(swipeLeftGestureRecognizer)
        }
    }
    
    @objc func handleDismissSettings()
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
            {
                self.moreView.alpha = 0
                if let window = UIApplication.shared.keyWindow
                {
                    self.collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                }
        }, completion: nil)
    }
    
    //Hàm vuốt hiện settings
    @objc func swipeLeftGesture()
    {
        print("Doing swipe left in menu setting")
        handleDismissSettings()
    }
    
    //Hàm ẩn setting
    func handleDismissClickOnSetting(setting: Setting)
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
            {
                self.moreView.alpha = 0
                if let window = UIApplication.shared.keyWindow
                {
                    self.collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                }
            }, completion:
            { (_) in
                guard let mainViewController = self.mainViewController
                    else { return }
                if setting.name == .sortByOrder
                {
                    mainViewController.isSorted = .sortByOrder
                    mainViewController.updateChildViewController()
                } else if setting.name == .sortByNumbericOrder
                {
                    mainViewController.isSorted = .sortByNumbericOrder
                    mainViewController.updateChildViewController()
                } else if setting.name == .sortReverseAlphabeticalOrder
                {
                    mainViewController.isSorted = .sortReverseAlphabeticalOrder
                    mainViewController.updateChildViewController()
                } else if setting.name == .sortByAlphabet
                {
                    mainViewController.isSorted = .sortByAlphabet
                    mainViewController.updateChildViewController()
                } else if setting.name == .termPrivacy
                {
                    mainViewController.showControllerForSetting(setting: setting)
                } else if setting.name == .sendFeedback
                {
                    mainViewController.showControllerForSetting(setting: setting)
                } else if setting.name == .help
                {
                    mainViewController.showControllerForSetting(setting: setting)
                }
            })
    }
    
    //MARK:- Các hàm callBack của collectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let setting = settings[indexPath.item]
        handleDismissClickOnSetting(setting: setting)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    { return settings.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        let setting = settings[indexPath.item]
        cell.setting = setting
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    { return 0 }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SettingCell
        header.nameLabel.text = "Settings"
        header.nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    //MARK:- Hàm khởi tạo của đối tượng SettingsLauncher
    override init()
    {
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SettingCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
}
