//
//  PlaylistResultViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-11.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer
import MediaPlayer
//import PageMenu

class PlaylistResultViewController: UIViewController, UIScrollViewDelegate{

    lazy var pl = storyboard!.instantiateViewController(withIdentifier: "newPlaylist") as! NewPlaylistViewController
    var curritem : MPMediaItemCollection? = nil
    var navController = UINavigationController()
    let mediaqueries = MediaQuery.init()
    let musicplayerapi = MusicPlayerControl.init()
    @IBOutlet var contentviewheight: NSLayoutConstraint!
    @IBOutlet var tableview: UITableView!
    var delegate : pagecontrollerprotocol?
    var segdelegate : seguefromsearch?
    let listofallplaylists = MPMediaQuery.playlists().collections
    @objc dynamic var playlistresultarr = [MPMediaItemCollection]()
    static let sharedInstance = PlaylistResultViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        playlistresultarr = listofallplaylists!
        registerCell()
        setupUI()
        self.preferredContentSize.height = CGFloat(listofallplaylists!.count * 58 + 100)
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 450, right: 0)
        self.tableview.contentInset = adjustForTabbarInsets
        self.tableview.scrollIndicatorInsets = adjustForTabbarInsets
        tableview.contentInsetAdjustmentBehavior = .never
        NotificationCenter.default.addObserver(self, selector: #selector(reloadtv), name: NSNotification.Name(rawValue: "load"), object: nil)
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
       //updateDelegate()
    }
    func setupUI()
    {

        
    }
    @objc func reloadtv()
    {
        tableview.reloadData()
    }
    
//    func updateDelegate()
//    {
//
//        let pageViewController = self.parent as! LibrarySearchPageViewController
//        self.delegate = pageViewController
//        delegate?.getVCIndex(vc: self)
//    }
//
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        PVC.sharedInstance.childDidStartSCrolling = true
    }
    func registerCell()
    {
        let SongListCell = UINib(nibName: "SongListCell", bundle: nil)
        self.tableview.register(SongListCell, forCellReuseIdentifier: "SongListCell")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        view.translatesAutoresizingMaskIntoConstraints = false
        tableview.translatesAutoresizingMaskIntoConstraints = false

        tableview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: tableview.contentSize.height)
        
    
        UIView.animate(withDuration: 0.5)
        {
            self.updateViewConstraints()
        }
        print()

    }


}
extension PlaylistResultViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if PlaylistResultViewController.sharedInstance.playlistresultarr.count == 0
        {
            return listofallplaylists!.count
        }
        else
        {
            return PlaylistResultViewController.sharedInstance.playlistresultarr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell") as? SongListCell
        var item : MPMediaItemCollection 
        if PlaylistResultViewController.sharedInstance.playlistresultarr.count == 0
        {
            item = playlistresultarr[indexPath.row] as! MPMediaPlaylist
        }
        else
        {
            item = PlaylistResultViewController.sharedInstance.playlistresultarr[indexPath.row] as! MPMediaPlaylist
        }
//         let newsize = CGSize(width: test.frame.size.width / 2, height: test.frame.size.height / 2)
//         test.image = playlist?.collageImage(rect: test.frame, images: playlist!.artworkImageArray(size:newsize))
        let oldsize = cell?.songartwork.frame.size
        let size = CGSize(width: oldsize!.width / 2, height: oldsize!.height / 2)
        cell?.songname.text = item.value(forProperty: MPMediaPlaylistPropertyName) as? String
        
        //if item.value(forProperty: MPMediaPlaylistProperty)
        if item.items.count == 0
        {
            cell?.songartwork.image = UIImage(named: "defaultmusicimage")
        }
        else
        {
//            let playlistartworklist = item.artworkImageArray(size: size)
//            if playlistartworklist.count < 4 && playlistartworklist.count > 0
//            {
//                cell?.songartwork.image = item.items[0].artwork?.image(at: oldsize!)
//            }
//            else
//            {
//                let playlistartwork = item.collageImage(rect: cell!.songartwork.frame, images: playlistartworklist)
//                cell?.songartwork.image = playlistartwork
//            }
            //                {
            let key = item.value(forProperty: MPMediaPlaylistPropertyPersistentID) as! NSNumber
            let savedimage = GlobalReferences().retrieveImage(forKey: key.stringValue + "min" )
            if  savedimage != nil
            {
                
                cell?.songartwork.image = savedimage
            }
            else
            {
                cell?.songartwork.image = item.items[0].artwork?.image(at: oldsize!)
            }
//            else
//            {
//                //let playlistartworklist1 = item.artworkImageArray(size: CGSize(width: 375 / 2 , height: 303 / 2))
//                let playlistartworklist = item.artworkImageArray(size: size)
//                if playlistartworklist.count < 4 && playlistartworklist.count > 0
//                {
//                    cell?.songartwork.image = item.items[0].artwork?.image(at: oldsize!)
//                }
//                else
//                {
//
//                    let playlistartwork = item.collageImage(rect: cell!.songartwork.frame, images: playlistartworklist)
//                    cell?.songartwork.image = playlistartwork
//                    //GlobalReferences().store(image: playlistartwork1, forKey: item.value(forProperty: MPMediaPlaylistPropertyName) as! String)
//                    //                GlobalReferences().delete(image: playlistartwork, forKey: item.value(forProperty: MPMediaPlaylistPropertyName) as! String)
//                    //let final = playlistartwork
//
//
//                }
//
//            }

        }

        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let pvc = (self.parent) as! CAPSPageMenu
//        print(pvc)
//        // storyboard!.instantiateViewController(identifier: "libraryvc") as LibraryViewController
//        segdelegate = self.parent as! LibraryViewController
//
//        segdelegate?.activateseguetoplaylist(playlist: listofallplaylists![indexPath.row])
        var item : MPMediaItemCollection
        if PlaylistResultViewController.sharedInstance.playlistresultarr.count == 0
        {
            item = playlistresultarr[indexPath.row] as! MPMediaPlaylist
        }
        else
        {
            item = PlaylistResultViewController.sharedInstance.playlistresultarr[indexPath.row] as! MPMediaPlaylist
        }
        
//        let key = item.value(forProperty: MPMediaPlaylistPropertyPersistentID) as! NSNumber
//        let savedimage = GlobalReferences().retrieveImage(forKey: key.stringValue + "min" )
//        if  savedimage != nil
//        {
//            
//            pl.mediaImage.image = savedimage
//        }
//        else
//        {
//            pl.mediaImage.image = item.items[0].artwork?.image(at: pl.mediaImage.frame.size)
//        }
        pl.playlist = item
        let backItem = UIBarButtonItem()
        backItem.tintColor = UIColor.logocolor!
        navigationItem.backBarButtonItem = backItem
        navigationController!.pushViewController(pl, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 58
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        var item : MPMediaItemCollection
        if PlaylistResultViewController.sharedInstance.playlistresultarr.count == 0
        {
            item = playlistresultarr[indexPath.row]
            curritem = item
        }
        else
        {
            item = PlaylistResultViewController.sharedInstance.playlistresultarr[indexPath.row]
            curritem = item 
        }
        let upnextaction = musicplayerapi.addupnextmenuaction(item: nil, album: item.items)
        return UIContextMenuConfiguration(identifier: nil, previewProvider:
        { () -> UIViewController? in

            var img = UIImage()
            let key = item.value(forProperty: MPMediaPlaylistPropertyPersistentID) as! NSNumber
            let savedimage = GlobalReferences().retrieveImage(forKey: key.stringValue + "min" )
//            if  savedimage != nil
//            {
//
//                img = savedimage!
//            }
////            if let image = item.representativeItem?.artwork
////            {
////                img = image.image(at: self.view.frame.size)!
////            }
//            else
//            {
//                img = UIImage(named: "defaultmusicimage")!
//            }
             if let image = item.items[0].value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
             {
                 img = image.image(at: CGSize(width: 300, height: 600))!
             }
             else
             {
                img = UIImage(named: "defaultmusicimage")!
             }
            return PreviewViewController(image: img)
        })
        { suggestedActions in
            return UIMenu(title: "", children: [upnextaction])
        }
    }
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating)
     {
    
         pl.playlist = curritem!
         let backItem = UIBarButtonItem()
         backItem.tintColor = UIColor.logocolor!
         navigationItem.backBarButtonItem = backItem
         navigationController!.pushViewController(pl, animated: true)
     }
    
    
}
