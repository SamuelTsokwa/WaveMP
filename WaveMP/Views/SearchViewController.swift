//
//  SearchViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-06.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer
import UPCarouselFlowLayout

class SearchViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate  {

    @IBOutlet var songresultheight: NSLayoutConstraint!
    @IBOutlet var albumresultheight: NSLayoutConstraint!
    @IBOutlet var songresultview: UIView!
    @IBOutlet var albumview: UIView!
    @IBOutlet var songresultviewheight: NSLayoutConstraint!
    @IBOutlet var albumresultviewheight: NSLayoutConstraint!
    @IBOutlet var songscv: UICollectionView!
    @IBOutlet var albumcv: UICollectionView!
    let mediaqueries = MediaQuery.init()
    let musicplayerapi = MusicPlayerControl.init()
    let listofallsongs = MPMediaQuery.songs().items
    let listofallalbum = MPMediaQuery.albums().collections
//    let listofallalbums = MPMediaQuery.albums().items
//    let listofallplaylists = MPMediaQuery.playlists().items
    var songresultarr = [MPMediaItem]()
    var albumresultarr = [MPMediaItemCollection]()
    
    //var alldata = [MPMediaItem]()
    var token: NSKeyValueObservation?
    var musicplayer = MPMusicPlayerController.applicationQueuePlayer
    
    
    
    @IBOutlet var contentviewheight: NSLayoutConstraint!
    @IBOutlet var contentview: UIView!
    @IBOutlet var searchbar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardWhenTappedAround()
        registerChatViewCell()
        registerObservers()
        //alldata = listofallsongs! + listofallalbums! + listofallplaylists!
        //token = songscv.observeValue(forKeyPath: "frame.height", of: <#T##Any?#>, change: <#T##[NSKeyValueChangeKey : Any]?#>, context: <#T##UnsafeMutableRawPointer?#>)NotificationCenter.default.addObserver(
        
       
    }
    

    override func viewDidAppear(_ animated: Bool)
    {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool)
    {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    lazy var miniplayerview : MiniPlayer =
       {
           let inputcontainerview = MiniPlayer(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65))
           //inputcontainerview.backgroundColor = UIColor(named: "miniplayercolor")
           inputcontainerview.backgroundColor = .clear
           //inputcontainerview.chatController = self
           inputcontainerview.translatesAutoresizingMaskIntoConstraints = false
           return inputcontainerview
           
       }()
    lazy var origin : CGFloat = searchbar.frame.origin.y
    
    func setupUI()
    {
        
        
        self.view.addSubview(miniplayerview)
        let guide = self.view.safeAreaLayoutGuide
        miniplayerview.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        miniplayerview.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        miniplayerview.heightAnchor.constraint(equalToConstant: 65).isActive = true
        miniplayerview.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        searchbar.layer.borderWidth = 0
        searchbar.setTextField(color: .tertiarySystemBackground)
        //searchbar.setTextColor(color: .black)
        //searchbar.tintColor = .black
        let layout = UPCarouselFlowLayout()
        let layout1 = UPCarouselFlowLayout()
        songscv.collectionViewLayout = layout
        albumcv.collectionViewLayout = layout1
        layout.itemSize = CGSize(width: 230, height: 248)
        layout.spacingMode = .fixed(spacing: 15)
        layout.scrollDirection = .horizontal
        layout1.itemSize = CGSize(width: 230, height: 248)
        layout1.spacingMode = .fixed(spacing: 15)
        layout1.scrollDirection = .horizontal
        
        
       
       
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView)
//    {
//    //
//
//        if scrollView.contentOffset.y > searchbar.frame.origin.y + 25
//        {
//
//            UIView.animate(withDuration: 0.7, animations: {
//
//                self.navigationController?.setNavigationBarHidden(false, animated: false)
//                self.navigationItem.title = "Search"
//                //self.navigationController?.navigationBar.addSubview(views)
//
//            }, completion: nil)
//        }
//        else
//        {
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
//            //navigationItem.title = nil
//        }
//    }
//
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
  
    
    func registerObservers()
    {
        songscv.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        albumcv.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        songresultview.layer.removeAllAnimations()
  
        if songresultarr.count == 0
        {
            songresultviewheight.constant = 0
            songresultheight.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                super.updateViewConstraints()

            }
        }
        else
        {
            songresultviewheight.constant = 316
            songresultheight.constant = 256
            print("ty1",songscv.contentSize.height, songresultviewheight.constant)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                super.updateViewConstraints()

            }
        }
        if albumresultarr.count == 0
        {
            albumresultheight.constant = 0
            albumresultviewheight.constant = 0
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                super.updateViewConstraints()

            }
        }
        else
        {
            albumresultviewheight.constant = 316
            albumresultheight.constant = 256
            print("ty1",songscv.contentSize.height, songresultviewheight.constant)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                super.updateViewConstraints()

            }
        }


    }
  
   
    
    
    
    func registerChatViewCell()
    {
        let NowPlayingCell = UINib(nibName: "NowPlayingCell", bundle: nil)
        
        self.songscv.register(NowPlayingCell, forCellWithReuseIdentifier: "NowPlayingCell")
        self.albumcv.register(NowPlayingCell, forCellWithReuseIdentifier: "NowPlayingCell")
        
    }
    
    
    
    
    func autoComplete(substring : String)
    {


        self.songresultarr = listofallsongs!.filter({ (item) -> Bool in
            let result = ((item.value(forKey: MPMediaItemPropertyTitle) as? String)!.lowercased().contains(substring.lowercased()))

            return result
        })
        self.albumresultarr = listofallalbum!.filter({ (item) -> Bool in
            let result = item.representativeItem?.albumTitle?.lowercased().contains(substring.lowercased())
            
            //let result = ((item.value(forKey: MPMediaItemPropertyTitle) as? String)!.lowercased().contains(substring.lowercased()))
            
            return result!
        })
        
        if songresultarr.count >= 4
        {
            self.songresultarr = Array(songresultarr[0...3])
        }
        if albumresultarr.count >= 4
        {
            self.albumresultarr = Array(albumresultarr[0...3])
        }


        songscv.reloadData()
        albumcv.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {


        let substring = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
        autoComplete(substring: substring)

                return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let backItem = UIBarButtonItem()

        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "searchtoalbum"
        {
            if let destinationVC = segue.destination as? AlbumViewController
            {
                if let album = sender as? [MPMediaItem]?
                {
                    destinationVC.album = album!
                }
                
            }
        }
        
        if segue.identifier == "searchtoplaylist"
        {
            if let destinationVC = segue.destination as? PlaylistViewController
            {
                
                destinationVC.playlist = sender as? MPMediaItemCollection
            }
        }
        
    }
//
    
    
    

}
extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == songscv
        {
            return songresultarr.count
        }
        if collectionView == albumcv
        {
            return albumresultarr.count
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.songscv.dequeueReusableCell(withReuseIdentifier: "NowPlayingCell", for: indexPath) as? NowPlayingCell
        let size = cell?.artwork.frame.size
        //var item = MPMediaItem()
        if collectionView == songscv
        {
            if songresultarr.count != 0
            {
                
                let item = songresultarr[indexPath.row]
                
                if let image = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                 {
                     cell?.artwork.layer.masksToBounds = true
                     cell?.artwork.image = image.image(at: size!)
                 }
                 else
                 {
                     cell?.artwork.image = UIImage(named: "defaultmusicimage")
                     
                 }
                 
                cell?.songname.text = item.value(forProperty: MPMediaItemPropertyTitle) as? String
                cell?.songartist.text = item.value(forProperty: MPMediaItemPropertyArtist) as? String
                
            }
        }
        if collectionView == albumcv
        {
            if albumresultarr.count != 0
            {
                let item = albumresultarr[indexPath.row]
                if let image = item.representativeItem?.artwork
                 {
                     cell?.artwork.layer.masksToBounds = true
                     cell?.artwork.image = image.image(at: size!)
                 }
                 else
                 {
                     cell?.artwork.image = UIImage(named: "defaultmusicimage")
                     
                 }
                 
                cell?.songname.text = item.representativeItem?.albumTitle
                cell?.songartist.text = item.representativeItem?.albumArtist
            }
        }
        
//        
//
//        if let image = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
//         {
//             cell?.artwork.layer.masksToBounds = true
//             cell?.artwork.image = image.image(at: size!)
//         }
//         else
//         {
//             cell?.artwork.image = UIImage(named: "defaultmusicimage")
//             
//         }
//         
//        cell?.songname.text = item.value(forProperty: MPMediaItemPropertyTitle) as? String
//        cell?.songartist.text = item.value(forProperty: MPMediaItemPropertyArtist) as? String
//         
         return cell!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == songscv
        {
            return CGSize(width: 230, height: 248)
        }
        if collectionView == albumcv
        {
            return CGSize(width: 230, height: 248)
        }
        return  CGSize(width: 0, height: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == songscv
        {
            let item = songresultarr[indexPath.row]
            var itemarr = [MPMediaItem]()
            itemarr.append(item)
            let coll = MPMediaItemCollection(items: itemarr)
            let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: coll)
            musicplayerapi.setQueueWithDescriptor(descriptor: descriptor)
//            musicplayerapi.setNowPlaying(item: item)
            musicplayerapi.play()
        }
        if collectionView == albumcv
        {
            let item = albumresultarr[indexPath.row].items
            performSegue(withIdentifier: "searchtoalbum", sender: item)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        if collectionView == songscv
//        {
//            let item = songresultarr[indexPath.row]
//            var albumarray = [MPMediaItem]()
//            let albumquery = MPMediaQuery.albums()
//            for album in (albumquery.items)!
//            {
//                if album.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String == item.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String && album.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String == item.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String
//                {
//                    
//                    albumarray.append(album)
//                   
//                }
//            }
//
//            
//            
//            let upnextaction = musicplayerapi.addupnextmenuaction(item: item, album: nil)
////            let viewalbumaction = musicplayerapi.viewalbmmenuaction(albumarray: albumarray, viewcontroller: self)
//            return UIContextMenuConfiguration(identifier: nil, previewProvider:
//                { () -> UIViewController? in
//
//                var img = UIImage()
//                if let image = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
//                {
//                    img = image.image(at: self.view.frame.size)!
//                }
//                else
//                {
//                    img = UIImage(named: "defaultmusicimage")!
//                }
//                
//                return PreviewViewController(image: img)
//            })
//            { suggestedActions in
////                return UIMenu(title: "", children: [viewalbumaction, upnextaction])
//            }
//        }
//        if collectionView == albumcv
//        {
//            let item = albumresultarr[indexPath.row]
//            let upnextaction = musicplayerapi.addupnextmenuaction(item: nil, album: item.items)
//            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
//                return UIMenu(title: "", children: [upnextaction])
//            }
//        }
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: nil)
//        
//    }
    
    
}
