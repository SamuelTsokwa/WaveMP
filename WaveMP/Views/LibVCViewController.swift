//
//  LibVCViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-07-19.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer
import Parchment

class LibVCViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    
    let playlistcontroller : PlaylistResultViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "libraryplaylists") as! PlaylistResultViewController
    let albumcontroller : AlbumResultViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "libraryalbums") as! AlbumResultViewController
    let songcontroller : SongResultViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "librarysongs") as! SongResultViewController
    var vcs : [UIViewController] = []
    let titles = ["Songs","Playlists","Albums"]
    
    let albumslist = MPMediaQuery.albums().collections
    let playlistslist = MPMediaQuery.playlists().collections
    let songslist = MPMediaQuery.playlists().items
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        vcs = [songcontroller,playlistcontroller,albumcontroller]
        setUpUI()
        registerObservers()
    }
    

    func setUpUI()
    {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.titleView = searchBar
        let backItem = UIBarButtonItem()
        backItem.tintColor = UIColor.logocolor!
        navigationItem.backBarButtonItem = backItem
//        searchBar.setShowsCancelButton(true, animated: true)
        let pagingViewController = PagingViewController()
        pagingViewController.dataSource = self
        pagingViewController.textColor = .gray
        pagingViewController.menuBackgroundColor = .black
        pagingViewController.borderOptions = .hidden
        pagingViewController.selectedTextColor = .white
        pagingViewController.indicatorColor = UIColor.logocolor!
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 80, height: 60)
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
          pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationController!.navigationBar.frame.height + 40)
        ])
        
        playlistcontroller.navController = self.navigationController!
        songcontroller.navController = self.navigationController!
        albumcontroller.navController = self.navigationController!
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = ""
        autoComplete(substring: "")
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
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

    
  
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        searchBar.resignFirstResponder()
        view.endEditing(true)
    }
    
    func registerObservers()
    {
        PVC.sharedInstance.addObserver(self, forKeyPath: "childDidStartSCrolling", options: .new, context: nil)
    }

}
extension LibVCViewController: PagingViewControllerDataSource,PagingViewControllerDelegate
{
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return vcs[index]
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return 3
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: titles[index])
    }
    
}
extension LibVCViewController: seguefromsearch
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
}
