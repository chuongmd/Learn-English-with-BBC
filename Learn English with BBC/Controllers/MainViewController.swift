//
//  MainViewController.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UISearchBarDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate
{
    //MARK:- Khai báo biến - hằng
    
    // Khai báo một segmentedControll - Chuyển đổi hiển thị dạng List hay Grid view
    var segmentedControl: UISegmentedControl!
    
    // Biến cờ đánh dấu trạng thái kết nối mạng, true là đã kết nối, false là không được kết nối
    var isConnected: Bool!
    
    // Mảng chứa Item trả về sau khi thực hiện việc tìm kiếm trên searchBar
    lazy var searchObjects = [Object]()
    
    // Biến cờ đánh dấu có đang search hay không
    var isSearching: Bool = false
    
    // Biến cờ đánh dấu có đang sắp xếp theo hay không
    var isSorted: Sorted = .sortByNumbericOrder
    
    // Biến chứa chuỗi Text tìm kiếm
    var searchText: String = ""
    
    // Biến chứa các phần tử sau khi Parser
    var dataList: [Item] = [Item]()
    
    // Biến đổi chiều của dataList
    var dataListReversed: [Item] = [Item]()
    
    // Biến chứa các phần tử được lưu trong Database sắp xếp theo Numberic Order
    var dataListObjectSBNO = [Object]()
    
    // Biến chứa các phần tử trong Database sắp xếp theo Order
    lazy var dataListObjectSBO = [Object]()
    
    // Biến chứa các phần tử trong Database sắp xếp theo Alphabet
    lazy var dataListObjectSBA = [Object]()
    
    // Biến chứa các phần tử trong Database sắp xếp theo Reversed Alphabet
    lazy var dataListObjectSRAO = [Object]()
    
    // Biến chứa các phần tử trong yêu thích trong CoreData
    var favoritesList = [Object]()
    
    let searchBar: UISearchBar =
    {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter text name here..."
        searchBar.searchBarStyle = .default
        searchBar.barStyle = .default
        searchBar.tintColor = UIColor.black
        searchBar.backgroundColor = UIColor.white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // Khởi tạo UIView chứa tableViewController và CollectionViewController khi addChild View
    let containerView = UIView()
    
    lazy var settingsLauncher: SettingsLauncher =
        {
            let settingsLauncher = SettingsLauncher()
            settingsLauncher.mainViewController = self
            return settingsLauncher
        }()
    
    func showControllerForSetting(setting: Setting)
    {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor.blue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    func showDetailViewControllerForFavorites(indexSelected: Int, objects: [Object])
    {
        let detailViewController = DetailViewController()
        detailViewController.indexCurrent = indexSelected
        detailViewController.dataListObjectDetail = objects
        detailViewController.favoritesListDetail = objects
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    lazy var favoritesLauncher: FavoritesLauncher =
        {
            let favoritesLauncher = FavoritesLauncher()
            favoritesLauncher.mainViewController = self
            return favoritesLauncher
        }()
    
    @objc func handleSettingsLauncher()
    {
        settingsLauncher.showSettings()
    }
    // Khởi tạo đối tượng tableViewController có kiểu UITableViewController
    var tableViewController: UITableViewController {
        let tableViewController = TableViewController()
        func sortSetting(isSorted: Sorted, dataListToSort: [Object])
        {
            tableViewController.isConnectedTable = isConnected
            tableViewController.isSortedTable = isSorted
            if isSearching
            {
                if self.searchText.count != 0 {
                    tableViewController.isSearchingTable = self.isSearching
                    tableViewController.searchObjectsTable = self.searchObjects
                    tableViewController.tableView.reloadData()
                } else
                {
                    tableViewController.dataListObjectTable = dataListToSort
                    tableViewController.tableView.reloadData()
                }
            } else
            {
                tableViewController.tableView.reloadData()
                tableViewController.dataListObjectTable = dataListToSort
                print(tableViewController.dataListObjectTable.count)
                
            }
        }
        
        if isSorted == .sortByNumbericOrder
        {
            sortSetting(isSorted: .sortByNumbericOrder, dataListToSort: dataListObjectSBNO)
            print(dataListObjectSBNO.count)
        } else if isSorted == .sortByOrder
        {
            sortSetting(isSorted: .sortByOrder, dataListToSort: dataListObjectSBO)
        } else if isSorted == .sortReverseAlphabeticalOrder
        {
            sortSetting(isSorted: .sortReverseAlphabeticalOrder, dataListToSort: dataListObjectSRAO)
        } else
        {
            sortSetting(isSorted: .sortByAlphabet, dataListToSort: dataListObjectSBA)
        }
        
        return tableViewController
    }
    
    // Khởi tạo đối tượng collectionViewController có kiểu UICollectionViewController
    var collectionViewController: UICollectionViewController
    {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionViewController = CollectionViewController(collectionViewLayout: flowLayout)
        func sortSetting(isSorted: Sorted, dataListToSort: [Object])
        {
            collectionViewController.isConnectedCollection = isConnected
            collectionViewController.isSortCollection = isSorted
            if isSearching
            {
                if self.searchText.count != 0
                {
                    collectionViewController.searchingCollection = self.isSearching
                    collectionViewController.searchObjectsCollection = self.searchObjects
                    collectionViewController.collectionView.reloadData()
                } else
                {
                    collectionViewController.dataListObjectCollection = dataListToSort
                    collectionViewController.collectionView.reloadData()
                }
            } else
            {
                collectionViewController.dataListObjectCollection = dataListToSort
                collectionViewController.collectionView.reloadData()
            }
        }
        if isSorted == .sortByNumbericOrder
        {
            sortSetting(isSorted: .sortByNumbericOrder, dataListToSort: dataListObjectSBNO)
        } else if isSorted == .sortByOrder
        {
            sortSetting(isSorted: .sortByOrder, dataListToSort: dataListObjectSBO)
        } else if isSorted == .sortReverseAlphabeticalOrder
        {
            sortSetting(isSorted: .sortReverseAlphabeticalOrder, dataListToSort: dataListObjectSRAO)
        } else if isSorted == .sortByAlphabet
        {
            sortSetting(isSorted: .sortByAlphabet, dataListToSort: dataListObjectSBA)
        }
        return collectionViewController
    }
    
    // MARK:- Khởi tạo dữ liệu ban đầu cho MainViewController
    
    func setupNavigationItem()
    {
        let leftButton = UIBarButtonItem(image: UIImage(named: "moreVertical_1"), style: .plain, target: self, action: #selector(handleSettingsLauncher))
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.title = "BBC English at Work"
    }
    
  
    func setupSearchBarAndContainerView()
    {
        searchBar.delegate = self
        
        self.view.addSubview(searchBar)
        self.view.addSubview(containerView)
        
        searchBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        searchBar.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setupSegmentedControl()
    {
        // Khởi tạo một segmentedControl có 2 item để mô tả 2 trạng thái hiển thị: dạng List - theo kiểu UITableView và dạng Grid - theo kiểu UICollectionView
        let listView = UIImage(named: "listView1")
        let gridView = UIImage(named: "gridView")
        segmentedControl = UISegmentedControl(items: ["List View", "Grid View"])
        segmentedControl.setImage(listView, forSegmentAt: 0)
        segmentedControl.setImage(gridView, forSegmentAt: 1)
        
        // Gán segmentedControll vào rightBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: segmentedControl)
        
        // Đặt vị trí mặc định cho segmentedControl luôn trỏ vào item thứ nhất(dạng List khi hiển thị)
        segmentedControl.selectedSegmentIndex = 0
        
        // Khai báo Action khi người dùng bấm chuyển qua lại giữa các item(chuyển qua lại giữa 2 dạng hiển thị)
        segmentedControl.addTarget(self, action: #selector(touchUpValueChange), for: .valueChanged)
    }
    
    @objc func touchUpValueChange()
    {
        updateChildViewController()
    }
    
    // Hàm khởi tạo dữ liệu lấy từ urlRSSFeed
    func createDataToUse()
    {
        //Thiết lập dữ liệu ban đầu
        //Tạo tham chiếu đến lớp XMLDataModel
        let dataModel = XMLDataModel(urlRSSFeed: "http://feeds.bbci.co.uk/learningenglish/english/features/english-at-work/rss")
        
        //Lấy dữ liệu đã Parser gán cho dataList
        self.dataList = dataModel.dataList
        
        //Đảo chiều các phần tử của mảng dataList và thêm các phần tử đó vào mảng mới có tên dataListReversed, xoá các phần tử của mảng dataList
        for item in self.dataList.reversed()
        {
            self.dataListReversed += [item]
            self.dataList.removeAll()
        }
        //Phần tử lỗi - Xoá khỏi mảng
        self.dataListReversed.remove(at: 0)
        print("Số phần tử của mảng dataListReversed là: \(self.dataListReversed.count)")
        
    }
    
    func setupDataWhenOnOffLine()
    {
        //Kiểm tra tình trạng kết nối mạng cho ứng dụng
        if CheckInternet.Connection()
        {
            print("Ứng dụng đã được kết nối mạng")
            print("Sử dụng dữ liệu lấy từ Server")
            isConnected = true
            //Kiểm tra xem có dữ liệu trong CoreData hay không, nếu có xoá hết dữ liệu và thêm mới, ngược lại thực hiện thêm mới khi dữ liệu không sẵn có
            self.dataListObjectSBNO = Object.getAllObject()
            print(dataListObjectSBNO.count)
            if self.dataListObjectSBNO.count == 0
            {
                self.createDataToUse()
                //Chèn các phần tử trong mảng dataListReversed vào CoreData(mảng [Object])
                for object in self.dataListReversed
                {
                    Object.insertNewObject(title: object.title, descriptions: object.descriptions, link: object.link, guid: object.guid, urlMedia: object.urlMedia, isFavorited: object.isFavorited, isExistedInCoreData: object.isExistedInCoreData)
                }
            } else if self.dataListObjectSBNO.count != 0
            {
                // Để chắc chắn dữ liệu luôn được cập nhật mới nhất từ Server, vẫn get và parser data từ Server ngay cả khi trong CoreData đã có dữ liệu
                self.createDataToUse()
                
                // Lọc lấy mảng các title của các Object có trong CoreData
                var titleLists = [String]()
                for object in self.dataListObjectSBNO
                {
                    titleLists += [object.title!]
                }
                // Duyệt các phần từ có được khi parser dữ liệu từ Server
                for item in self.dataListReversed
                {
                    
                    // Kiểm tra xem item đã có trong CoreData hay chưa, dựa vào title của mỗi item. Nếu có bỏ qua item đó, nếu chưa có thêm item đó vào trong CoreData
                    if titleLists.contains(item.title)
                    {
                        print("Phần tử đã tồn tại trong CoreData")
                    } else
                    {
                        print("Phần tử chưa có trong CoreData, hãy thêm mới ")
                        Object.insertNewObject(title: item.title, descriptions: item.descriptions, link: item.link, guid: item.guid, urlMedia: item.urlMedia, isFavorited: item.isFavorited, isExistedInCoreData: item.isExistedInCoreData)
                    }
                }
            }
            self.dataListObjectSBNO = Object.getAllObject()
            for object in self.dataListObjectSBNO.reversed()
            {
                dataListObjectSBO += [object]
                if object.isFavorited
                { self.favoritesList += [object] }
            }
            print("Số lượng phần tử yêu thích: \(favoritesList.count)")
            dataListObjectSBA = dataListObjectSBNO.sorted(by: { $0.title! < $1.title! })
            dataListObjectSRAO = dataListObjectSBNO.sorted(by: { $0.title! > $1.title! })
        } else
        {
            print("Ứng dụng không được kết nối mạng")
            AlertView.showAlert(view: self, title: "Thông báo !", message: "Ứng dụng không được kết nối mạng !")
            isConnected = false
            dataListObjectSBNO = Object.getAllObject()
            for object in self.dataListObjectSBNO.reversed()
            {
                dataListObjectSBO += [object]
                if object.isFavorited { self.favoritesList += [object]}
            }
            dataListObjectSBA = dataListObjectSBNO.sorted(by: { $0.title! < $1.title! })
            dataListObjectSRAO = dataListObjectSBNO.sorted(by: { $0.title! > $1.title! })
        }
    }
    
    func setupNavBarBackgroundColor()
    {
        navigationController?.navigationBar.backgroundColor = UIColor.cyan
        view.backgroundColor = UIColor.white
    }

    //MARK:- Các hàm MainViewController LifeCycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupDataWhenOnOffLine()
        setupSegmentedControl()
        updateChildViewController()
        setupNavBarBackgroundColor()
        setupNavigationItem()
        setupSearchBarAndContainerView()
        setupSwipeGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
    }
    
    // MARK:- Các hàm thực hiện thêm và gỡ ChildViewController khỏi MainViewController
    // Thêm ChildViewController
    func add(asChildViewController viewController: UIViewController)
    {
        
        // Thêm ChildViewController
        addChild(viewController)
        
        // Thêm Subview cho UIView(containerView) của SegmentedViewController
        containerView.addSubview(viewController.view)
        
        // Cấu hình UIView của ChildViewController
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Thông báo đã hoàn tất thêm Child ViewController
        viewController.didMove(toParent: self)
    }
    // Gỡ ChildViewController
    func remove(asChildViewController viewController: UIViewController)
    {
        // Thông báo sẽ remove ChildViewController
        viewController.willMove(toParent: nil)
        
        // Gỡ Child View khỏi Superview(UIView - containerView: của SegmentedViewControl)
        viewController.view.removeFromSuperview()
        
        // Thực hiện gỡ ChildViewController khỏi SegmentedViewControl
        viewController.removeFromParent()
    }
    
    // Hàm update ChildViewController với SegmenteControl
    func updateChildViewController()
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            remove(asChildViewController: collectionViewController)
            add(asChildViewController: tableViewController)
        } else
        {
            remove(asChildViewController: tableViewController)
            add(asChildViewController: collectionViewController)
        }
    }
    
    //MARK:- Các hàm thực hiện tìm kiếm dữ liệu theo tên
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    { isSearching = true }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    { isSearching = false }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchText = searchText
        if isSearching
        {
            if searchText.count != 0 {
                searchObjects = dataListObjectSBNO.filter({$0.title!.lowercased().contains(searchText.lowercased())})
                updateChildViewController()
            } else
            {
                searchObjects = []
                updateChildViewController()
            }
        }
    }
    
    // MARK:- Thiết lập hàm thực hiện cử chỉ vuốt để hiện menu Settings
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
        
        //Thêm swipe vào view
        view.addGestureRecognizer(swipeLeftGestureRecognizer)
        view.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    
    @objc func swipeGesture(sender: UISwipeGestureRecognizer)
    {
        if (sender.direction == .left)
        {
            print("Doing Swipe Left")
            self.favoritesLauncher.isConnectedFavorites = isConnected
            self.favoritesLauncher.showFavorites()
        } else
        {
            print("Doing Swipe Right")
            self.settingsLauncher.showSettings()
        }
    }
}
