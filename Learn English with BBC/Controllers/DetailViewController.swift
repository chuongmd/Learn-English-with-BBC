//
//  DetailViewController.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate
{
    //MARK:- Khai báo biến - hằng
    
    var tableViewController = TableViewController()
    var collectionViewController = CollectionViewController()
    var favoritesLauncher = FavoritesLauncher()
    
    //Mảng chứa các item được truyền từ TableView hoặc CollectionView trước
    var dataListObjectDetail: [Object] = []
    
    // Biến chứa các phần tử trong yêu thích trong CoreData
    var favoritesListDetail = [Object]()
    
    //Item hiện tại được load(item của hàng hay ô được chọn)
    var objectCurrent: Object?
    
    //Vị trí của item trong mảng - Vị trí được chọn để load
    var indexCurrent: Int!
    
    //Toạ độ theo trục Y - chiều dọc màn hình, dùng khi cuộn trang
    var lastOffsetY: CGFloat = 0
    
    // Khai báo WKWebView
    var webView: WKWebView!
    
    // Thiết lập các thông cố cấu hình cho WKWebView
    override func loadView()
    {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    // Khởi tạo 1 progressView hiển thị trạng thái tải trang của WKWebView
    let progressView: UIProgressView =
    {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()
    
    func setupProgressView()
    {
        //Khi present hoặc show ViewController sẽ luôn tồn tại một NavigationBar -> Gắn progressView vào UIView của navigationBar
        let navigationbar = navigationController?.navigationBar
        navigationbar?.addSubview(progressView)
    
        progressView.leftAnchor.constraint(equalTo: navigationbar!.leftAnchor ).isActive = true
        progressView.rightAnchor.constraint(equalTo: navigationbar!.rightAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: (navigationbar?.bottomAnchor)!).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    // KHởi tạo nút back về item trước đó
    let backButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonItemAction))
    
    // Khởi tạo khoảng trống giữa 2 nút
    let spaceButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    
    // Khởi tạo nút forward tới item phía sau item hiện tại
    let forwardButtonItem = UIBarButtonItem(image: UIImage(named: "forward"), style: .plain, target: self, action: #selector(forwardButtonItemAction))
    
    // Khởi tạo nút action cho item hiện tại
    let actionButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleActions))
    
    // Khởi tạo nút action cho item hiện tại
    let bookmarksButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(handleBookmarks))
    
    // Khởi tạo toolBar
    let toolBarWKWebView: UIToolbar =
    {
        let tb = UIToolbar()
        tb.tintColor = UIColor.white
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    func setupToolBarWKWebView()
    {
        backButtonItem.tintColor = UIColor.blue
        forwardButtonItem.tintColor = UIColor.blue
        actionButtonItem.tintColor = UIColor.blue
        bookmarksButtonItem.tintColor = UIColor.blue
        
        // Insert 3 nút vào toolBar
        toolBarWKWebView.items = [backButtonItem, spaceButtonItem, actionButtonItem, spaceButtonItem, forwardButtonItem]
        webView.addSubview(toolBarWKWebView)
        //Constraint toolBarWKWebView
        toolBarWKWebView.leftAnchor.constraint(equalTo: self.webView.leftAnchor).isActive = true
        toolBarWKWebView.rightAnchor.constraint(equalTo: self.webView.rightAnchor).isActive = true
        toolBarWKWebView.bottomAnchor.constraint(equalTo: self.webView.bottomAnchor).isActive = true
        toolBarWKWebView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    //MARK:- Các hàm thiết lập ban đầu
    
    //Hàm load WKWebView item được chọn khi chuyển sang DetailViewController
    func loadDetail(_ indexList: Int)
    {
        objectCurrent = dataListObjectDetail[indexList]
        //Tạo biến chứa link URL(dữ liệu thô) của image
        var selectedLinkUrl = objectCurrent!.link
        //Loại bỏ khoảng trống và ký tự không phù hợp cho URL
        selectedLinkUrl = selectedLinkUrl!.replacingOccurrences(of: " ", with: "")
        selectedLinkUrl = selectedLinkUrl!.replacingOccurrences(of: "\n", with: "")
        print("Bạn đang truy cập vào địa chỉ: \(selectedLinkUrl ?? "")")
        guard let url = URL(string: selectedLinkUrl!) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    //Hàm custom NavigationBar
    func setupNavBarTitle(_ indexList: Int)
    {
        objectCurrent = dataListObjectDetail[indexList]
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 260, height: 44)
        titleView.backgroundColor = UIColor.red
        
        //Khởi tạo image cho object hiện tại
        let imageTitleView = UIImageView()
        imageTitleView.contentMode = .scaleAspectFill
        imageTitleView.layer.cornerRadius = 18
        imageTitleView.clipsToBounds = true
        if objectCurrent!.isFavorited
        {
            imageTitleView.layer.borderColor = UIColor.red.cgColor
            imageTitleView.layer.borderWidth = 2
        } else
        {
            imageTitleView.layer.borderColor = UIColor.clear.cgColor
            imageTitleView.layer.borderWidth = 2
        }
        imageTitleView.translatesAutoresizingMaskIntoConstraints = false
        imageTitleView.loadImageCacheWithUrlString(urlString: objectCurrent!.urlMedia!, imageSize: CGSize(width: 36, height: 36))
        
        //Khởi tạo label cho object hiện tại
        let labelTitle = UILabel()
        labelTitle.text = objectCurrent?.title!
        labelTitle.font = UIFont.boldSystemFont(ofSize: 18)
        labelTitle.numberOfLines = 2
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(imageTitleView)
        titleView.addSubview(labelTitle)
        
        imageTitleView.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 0).isActive = true
        imageTitleView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        imageTitleView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        imageTitleView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
        labelTitle.leftAnchor.constraint(equalTo: imageTitleView.rightAnchor, constant: 8).isActive = true
        labelTitle.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        labelTitle.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        labelTitle.heightAnchor.constraint(equalTo: imageTitleView.heightAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    //Hàm ẩn hiện nút back và forward khi hàng được chọn ở vị trí đầu tiên, cuối cùng hay ở giữa của danh sách
    func enableButtonItem()
    {
        //Ẩn - hiện backButtonItem
        if indexCurrent == 0
        { backButtonItem.isEnabled = false }
        else
        { backButtonItem.isEnabled = true }
        //Ẩn - hiện forwardButtonItem
        if indexCurrent == dataListObjectDetail.count - 1
        { forwardButtonItem.isEnabled = false }
        else
        { forwardButtonItem.isEnabled = true }
    }
    
    // MARK:- Hàm back - forward tới bài trước và sau bài hiện tại trong danh sách
    
    @objc func backButtonItemAction(_ sender: UIBarButtonItem)
    {
        //Kiểm tra xem Item đã chọn có phải hàng đầu tiên trong tableView không
        enableButtonItem()
        
        let indexBack = indexCurrent - 1
        if indexBack >= 0
        {
            loadDetail(indexBack)
            setupNavBarTitle(indexBack)
            print("Thực hiện tải phần tử thứ: \(indexBack) trong mảng objectArray")
        } else
        {
            print("Đây là hàng đầu tiên trong danh sách")
            return
        }
        indexCurrent -= 1
        enableButtonItem()
    }
    
    @objc func forwardButtonItemAction(_ sender: UIBarButtonItem)
    {
        //Kiểm tra xem Item đã chọn có phải hàng cuối cùng trong tableView không
        enableButtonItem()
        let indexForward = indexCurrent + 1
        if indexForward < dataListObjectDetail.count
        {
            loadDetail(indexForward)
            setupNavBarTitle(indexForward)
            print("Thực hiện tải phần tử thứ: \(indexForward) trong mảng objectArray")
        } else
        {
            print("Đây là hàng cuối cùng trong danh sách!")
            //Nếu không return sẽ xuất hiện lỗi: Index out of range. Vì khi đó giá trị của index đã nằm ngoài khoảng giá trị index của mảng ItemArray, do vậy khi nhấn Back để quay lại item phía sau nó, sẽ báo lỗi vì không có item nào cả
            return
        }
        indexCurrent += 1
        enableButtonItem()
    }
    
    lazy var actionsLauncher = ActionsLauncher()
    @objc func handleActions(_ sender: UIBarButtonItem)
    {
        actionsLauncher.dataListObjectAction = self.dataListObjectDetail
        actionsLauncher.favoriteObject = objectCurrent
        actionsLauncher.favoritesListAction = self.favoritesListDetail
        actionsLauncher.indexCurrent = self.indexCurrent
        actionsLauncher.showActions()
        print("Số phần tử favorite là: \(actionsLauncher.favoritesListAction.count)")
    }
    
    @objc func handleBookmarks(_ sender: UIBarButtonItem)
    { print("This is bookmark") }
    
    // MARK:- Hàm Reload và Back
    func setupLeftRightBarButtonItem()
    {
        // Nút back trở về màn hình chọn trước đó
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backViewController))
        
        // Nút reload để tải lại trang
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadWKWebView))
    }
    
    //Quay lại màn hình danh sách
    @objc func backViewController(_ sender: UIBarButtonItem)
    {
        // Dùng khi push view từ FavoritesLauncher quick menu
        webView.stopLoading()
        navigationController?.popViewController(animated: true)
        
        // Dùng khi present từ tableView hoặc collectionView
        dismiss(animated: true, completion: nil)
    }
    
    // Tải lại trang hiện tại
    @objc func reloadWKWebView(_ sender: UIBarButtonItem)
    { self.webView.reload() }
    
    //MARK:- Các hàm ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        actionsLauncher.detailViewController = self
    
        setupLeftRightBarButtonItem()
        loadDetail(indexCurrent)
        setupProgressView()
        setupToolBarWKWebView()
        setupSwipeGestureRecognizer()
        enableButtonItem()
        setupNavBarTitle(indexCurrent)
        
        webView.scrollView.delegate = self
        
        //Để sử dụng các hàm của WKNavigationDelegate
        webView.navigationDelegate = self
    }
    
    //MARK:- Hàm thực hiện việc vuốt chuyển bài
    fileprivate func setupSwipeGestureRecognizer()
    {
        //Khởi tạo đối tượng để có thể phản hồi khi người dùng vuốt trên màn hình
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        
        //Cài đặt hướng vuốt
        swipeLeftGestureRecognizer.direction = .left
        swipeRightGestureRecognizer.direction = .right
        
        swipeLeftGestureRecognizer.delegate = self
        swipeRightGestureRecognizer.delegate = self
        
        //Thêm swipe vào WKWebView
        webView.addGestureRecognizer(swipeLeftGestureRecognizer)
        webView.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    
    @objc func swipeGesture(sender: UISwipeGestureRecognizer)
    {
        if (sender.direction == .left)
        {
            enableButtonItem()
            let indexBack = indexCurrent + 1
            if indexBack < dataListObjectDetail.count
            {
                loadDetail(indexBack)
                setupNavBarTitle(indexBack)
            } else
            {
                print("Đây là hàng đầu tiên trong danh sách")
                return
            }
            indexCurrent += 1
            enableButtonItem()
        } else
        {
            if (sender.direction == .right)
            {
                enableButtonItem()
                let indexForward = indexCurrent - 1
                if indexForward >= 0
                {
                    loadDetail(indexForward)
                    setupNavBarTitle(indexForward)
                } else
                {
                    print("Đây là hàng cuối cùng trong danh sách!")
                    return
                }
                indexCurrent -= 1
                enableButtonItem()
            }
        }
    }
    
    //Hàm hỏi delegate để cho phép thực hiện các cử chỉ, động tác vuốt, chạm
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
    //MARK:- Hàm cài đặt trạng thái của ProgressView
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "estimatedProgress"
        {
            print(self.webView.estimatedProgress);
            self.progressView.progress = Float(self.webView.estimatedProgress);
        }
    }
    
    //Hàm sử dụng khi bắt đầu tải trang - Hiện ProgressView
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        progressView.isHidden = false
        print("Bắt đầu tải trang")
    }
    //Hàm tải trang hoàn tất của WKWebView  - sẽ ẩn ProgressView
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        progressView.isHidden = true
        print("Đã hoàn thành tải trang.")
    }
    
    //MARK:- Hàm ẩn navigationBar và toolBar khi cuộn
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        //Xác định toạ độ theo chiều dọc màn hình khi bắt đầu cuộn
        lastOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if scrollView.contentOffset.y > self.lastOffsetY
        {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.toolBarWKWebView.isHidden = true
        } else
        {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.toolBarWKWebView.isHidden = false
        }
    }
}





























// Bổ xung - nếu sử dụng ActivityIndicator

//MARK:- Hàm cài đặt trạng thái của INDICATOR
/* SỬ DỤNG ACTIVITY INDICATOR
 
 func showActivityIndicator(show: Bool) {
 if show {
 activityIndicator.startAnimating()
 print("Bắt đầu tải trang: \(objectCurrent!.link)")
 } else {
 activityIndicator.stopAnimating()
 print("Kết thúc tải trang: \(itemCurrent!.link)")
 }
 }
 
 //Hiển thị indicator khi WKWebView bắt đầu tải trang
 func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
 
 showActivityIndicator(show: true)
 }
 
 //Ẩn indicator khi WKWebView kết thúc tải trang
 func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
 
 showActivityIndicator(show: false)
 }
 
 */
