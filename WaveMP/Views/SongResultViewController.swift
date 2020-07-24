//
//  SongResultViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-11.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer

class SongResultViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    
    @IBOutlet var tableview: UITableView!
    
    var curritem : MPMediaItem? = nil

    var vc : MainPlayerViewController!

    var navController = UINavigationController()
    var musicplayer = MPMusicPlayerController.applicationQueuePlayer
    let mediaqueries = MediaQuery.init()
    let musicplayerapi = MusicPlayerControl.init()
    var delegate : seguefromsearch?
    let listofallsongs = MPMediaQuery.songs().items
    @objc dynamic var songsresultarr = [MPMediaItem]()
    static let sharedInstance = SongResultViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        songsresultarr = listofallsongs!
        registerCell()
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 450, right: 0)
        self.tableview.contentInset = adjustForTabbarInsets
        self.tableview.scrollIndicatorInsets = adjustForTabbarInsets
        tableview.contentInsetAdjustmentBehavior = .never
        NotificationCenter.default.addObserver(self, selector: #selector(reloadtv), name: NSNotification.Name(rawValue: "load"), object: nil)
        vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainPlayer")


    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       //updateDelegate()
    }
    
     
    
    @objc func reloadtv()
    {
         tableview.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        PVC.sharedInstance.childDidStartSCrolling = true
    }
    
//    func updateDelegate()
//    {
//
//        let pageViewController = self.parent as! LibrarySearchPageViewController
//        self.delegate = pageViewController
//        //delegate?.getVCIndex(vc: self)
//        delegate?.getVCIndex(vc: self)
//    }
    func registerCell()
    {
        let SongListCell = UINib(nibName: "SongListCell", bundle: nil)
        self.tableview.register(SongListCell, forCellReuseIdentifier: "SongListCell")
    }
    override var childForStatusBarHidden: UIViewController?
    {
        return vc
    }
   

    

}
extension SongResultViewController
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SongResultViewController.sharedInstance.songsresultarr.count == 0
        {
            return listofallsongs!.count
        }
        else
        {
            return SongResultViewController.sharedInstance.songsresultarr.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell") as? SongListCell
        let size = cell?.songartwork.frame.size
        var item : MPMediaItem
        if SongResultViewController.sharedInstance.songsresultarr.count == 0
        {
            item = songsresultarr[indexPath.row]
        }
        else
        {
            item = SongResultViewController.sharedInstance.songsresultarr[indexPath.row]
        }
        cell?.songname.text = item.title
        cell?.songartist.text = item.artist
        
        if let image = item.artwork
        {
            cell?.songartwork.image = image.image(at: size!)
        }
        else
        {
            cell?.songartwork.image = UIImage(named: "defaultmusicimage")
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        58
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item : MPMediaItem?
        if SongResultViewController.sharedInstance.songsresultarr.count == 0
        {
            item = listofallsongs![indexPath.row]
        }
        else
        {
            item = SongResultViewController.sharedInstance.songsresultarr[indexPath.row]
        }
        
        var itemarr = [MPMediaItem]()
        itemarr.append(item!)
        let coll = MPMediaItemCollection(items: itemarr)
        let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: coll)
        musicplayerapi.setQueueWithDescriptor(descriptor: descriptor)
        musicplayerapi.play()
        tableView.deselectRow(at: indexPath, animated: true)
        //Lyrics().testAPI(item: item!)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
   
        let item : MPMediaItem?
        if SongResultViewController.sharedInstance.songsresultarr.count == 0
        {
            item = listofallsongs![indexPath.row]
            curritem = item
        }
        else
        {
            item = SongResultViewController.sharedInstance.songsresultarr[indexPath.row]
            curritem = item
        }
        
        var albumarray = [MPMediaItem]()
        let albumquery = MPMediaQuery.albums()
        for album in (albumquery.items)!
        {
            if album.title == item?.albumTitle && album.albumArtist == item?.albumArtist
            {
                albumarray.append(album)
            }
//            if album.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String == item!.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String && album.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String == item!.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String
//               {
//
//                   albumarray.append(album)
//               }
         }

                   
                   
        let upnextaction = musicplayerapi.addupnextmenuaction(item: item, album: nil)
        //let viewalbumaction = musicplayerapi.viewalbmmenuaction(albumarray: albumarray, viewcontroller: self)
        return UIContextMenuConfiguration(identifier: nil, previewProvider:
        { () -> UIViewController? in

            var img = UIImage()
            if let image = item?.artwork
            {
                img = image.image(at: self.view.frame.size)!
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
        let item : MPMediaItem = curritem!
       
                
        var albumarray = [MPMediaItem]()
        let albumquery = MPMediaQuery.albums().collections!
        print()
        for album in albumquery
        {
            if album.representativeItem?.albumTitle == item.albumTitle && album.representativeItem?.albumArtist == item.artist
            {
                //albumarray.append((album.items))
                albumarray.append(contentsOf: album.items)
            }
        }
        
        let av : AlbumViewController = storyboard?.instantiateViewController(identifier: "album") as! AlbumViewController
        av.album = albumarray
        navController.pushViewController(av, animated: true)
    }

}
