//
//  LibraryViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-08.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer
import Parchment

//class LibraryViewController: UIViewController, UIScrollViewDelegate, CAPSPageMenuDelegate, UISearchBarDelegate {
class LibraryViewController: UIScrollViewDelegate, UISearchBarDelegate {

    var vc : MainPlayerViewController!

    @IBOutlet var searchbar: UISearchBar!
    @IBOutlet var contentviewheight: NSLayoutConstraint!
    @IBOutlet var contentview: UIView!
    let playlistHeader = UIButton()
    let albumHeader = UIButton()
    let songHeader = UIButton()
//    var delegate : pagecontrollerprotocol?
    var groupingHeaders = [UIButton]()
    let albumslist = MPMediaQuery.albums().collections
    let playlistslist = MPMediaQuery.playlists().collections
    let songslist = MPMediaQuery.playlists().items
    var currentPage  = 0
    var pagemenucon : NSLayoutConstraint?
    @IBOutlet var scrollview: UIScrollView!
    
    lazy var activityIndicatorView: UIActivityIndicatorView =
    {
        let aiv = UIActivityIndicatorView(style: .medium)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        
        return aiv
    }()
    lazy var miniplayerview : MiniPlayer =
    {
        let inputcontainerview = MiniPlayer(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65))
           //inputcontainerview.backgroundColor = UIColor(named: "miniplayercolor")
        inputcontainerview.backgroundColor = .clear
        inputcontainerview.viewcontroller = self
        inputcontainerview.translatesAutoresizingMaskIntoConstraints = false
        return inputcontainerview
           
    }()
    let playlistcontroller : PlaylistResultViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "libraryplaylists") as! PlaylistResultViewController
    let albumcontroller : AlbumResultViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "libraryalbums") as! AlbumResultViewController
    let songcontroller : SongResultViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "librarysongs") as! SongResultViewController

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardWhenTappedAround()
        registercell()
//        pageMenu?.delegate = self
        registerObservers()
        vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainPlayer")
        let pagingViewController = PagingViewController(viewControllers: [
             songcontroller,
             
           ])
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
          pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        
    }

    
    override func viewDidAppear(_ animated: Bool)
    {
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barTintColor = UIColor.clear
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupUI()
    {
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []

//
//        playlistcontroller.navController = self.navigationController!
//        songcontroller.navController = self.navigationController!
//        albumcontroller.navController = self.navigationController!
//
//        songcontroller.title = "Songs"
//        controllerArray.append(songcontroller)
//        playlistcontroller.title = "Playlists"
//        controllerArray.append(playlistcontroller)
//        albumcontroller.title = "Albums"
//        controllerArray.append(albumcontroller)
//
//
//
//
////
////         Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
////         Example:
//        let parameters: [CAPSPageMenuOption] =
//        [
//            .menuItemSeparatorWidth(4.3), .useMenuLikeSegmentedControl(true), .viewBackgroundColor(.clear), .scrollMenuBackgroundColor(.clear), .selectionIndicatorHeight(0.6), .unselectedMenuItemLabelColor(UIColor.darkGray), .menuItemSeparatorPercentageHeight(0)
//        ]
//
//
//        // Initialize page menu with controller array, frame, and optional parameters
//        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: contentview.frame.width, height: contentview.frame.height), pageMenuOptions: parameters)
//
//
//        // Lastly add page menu as subview of base view controller view
//        // or use pageMenu controller in you view hierachy as desired
//        pageMenu?.view.translatesAutoresizingMaskIntoConstraints = false
//        //self.addChild(pageMenu!)
//        pagemenucon = NSLayoutConstraint(item: pageMenu!.view!, attribute: .height, relatedBy: .equal, toItem: contentview, attribute: .height, multiplier: 1, constant: CGFloat(playlistslist!.count * 58) + 200)
//
//        contentview.addSubview(pageMenu!.view)
//        pageMenu?.view.translatesAutoresizingMaskIntoConstraints = false
//        pageMenu?.view.topAnchor.constraint(equalTo: searchbar.bottomAnchor, constant: 13).isActive = true
//        pageMenu?.view.widthAnchor.constraint(equalToConstant: contentview.frame.width).isActive = true
//        pagemenucon?.isActive = true
//        contentviewheight.constant = pagemenucon!.constant + 197


    }
    func registercell()
    {
        //cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    func registerObservers()
    {
        PVC.sharedInstance.addObserver(self, forKeyPath: "childDidStartSCrolling", options: .new, context: nil)
    }

 
    func editGroupingHeader(){}
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {

        if let _ = scrollView as? UICollectionView
        {
    
        }
        //print(searchbar.frame.origin.y)
        
               
    }
    func autoComplete(substring : String)
    {
        PlaylistResultViewController.sharedInstance.playlistresultarr = playlistslist!.filter({ (item) -> Bool in
            let result = (item as! MPMediaPlaylist).name?.lowercased().contains(substring.lowercased())
            return result!
        })
        AlbumResultViewController.sharedInstance.albumresultarr = albumslist!.filter({ (item) -> Bool in
            let result = item.representativeItem?.albumTitle?.lowercased().contains(substring.lowercased())
            return result!
        })
        
        SongResultViewController.sharedInstance.songsresultarr = songslist!.filter({ (item) -> Bool in
            let result = item.title?.lowercased().contains(substring.lowercased())
            return result!
        })

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let substring = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
        autoComplete(substring: substring)

        return true
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()

        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "searchtoplaylist"
        {
            if let destinationVC = segue.destination as? PlaylistViewController
            {
                print(destinationVC)
                destinationVC.playlist = sender as? MPMediaItemCollection
            }
        }
    }
    override var childForStatusBarHidden: UIViewController?
    {
        return vc
    }
    
}

extension LibraryViewController: seguefromsearch
{
    func activateseguetoAlbum(album: [MPMediaItem]?)
    {
        DispatchQueue.main.async()
        {
           self.performSegue(withIdentifier: "searchtoalbum", sender: album)
        }
        
    }
    
    func activateseguetoplaylist(playlist: MPMediaItemCollection?)
    {
        DispatchQueue.main.async()
        {
           self.performSegue(withIdentifier: "searchtoplaylist", sender: playlist)
        }
        
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        //controller.preferredContentSize =
        
        
    }
    func didMoveToPage(_ controller: UIViewController, index: Int)
    {
        //pagemenucon?.constant = controller.preferredContentSize.height
//        contentviewheight.constant = controller.preferredContentSize.height
//        print(controller,controller.preferredContentSize.height,contentviewheight.constant,pageMenu?.view.frame.height)
//        UIView.animate(withDuration: 0.3) {
//            self.updateViewConstraints()
//        }
    }
    
    
    
    
}
extension LibraryViewController: PageMenuControllerDataSource, PageMenuControllerDelegate
{
    func viewControllers(forPageMenuController pageMenuController: PageMenuController) -> [UIViewController] {
        return [playlistcontroller]
    }
    
    func menuTitles(forPageMenuController pageMenuController: PageMenuController) -> [String] {
        return ["Songs"]
    }
    
    func defaultPageIndex(forPageMenuController pageMenuController: PageMenuController) -> Int {
        return 0
    }
    
    
}
