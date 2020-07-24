//
//  PlaylistViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-06.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer
import EFAutoScrollLabel


class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate  {
    
    var nowplayingdelegate : updateCell?

    @IBOutlet var test: UIImageView!
    var vc : MainPlayerViewController!
    @IBOutlet var otherplaylistdataheight: NSLayoutConstraint!
    @IBOutlet var otherplaylistdata: UITextView!
    @IBOutlet var playlistdescriptiontext: UILabel!
    @IBOutlet var descriptionboxheight: NSLayoutConstraint!
    @IBOutlet var descriptionbox: UIView!
    let mediaqueries = MediaQuery.init()
    let musicplayerapi = MusicPlayerControl.init()
    @IBOutlet var playlisttableheight: NSLayoutConstraint!
    @IBOutlet var contentviewheight: NSLayoutConstraint!
    var musicplayer = MPMusicPlayerController.applicationQueuePlayer
    @IBOutlet var contentView: UIView!
    @IBOutlet var playlisttable: UITableView!
    var reversedPlaylist = [MPMediaItem]()
    var isRecentlyAdded = false
    var playlist : MPMediaItemCollection?
    static let sharedInstance = PlaylistViewController()
    var ob : NSObjectProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
//        NotificationCenter.default.addObserver(
//        self,
//        selector: #selector(monitorplayerqueuechange),
//        name: .MPMusicPlayerControllerQueueDidChange,
//        object: nil
//            )
        
        //
        registerChatViewCell()
        //checkNowPlaying
        self.playlisttable.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        //self.descriptionbox.addObserver(self, forKeyPath: "intrinsicContentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(monitorNowPlaying),
        name: .MPMusicPlayerControllerNowPlayingItemDidChange,
        object: musicplayer
            )
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(handleMusicPlayerControllerPlaybackStateDidChange),
        name: .MPMusicPlayerControllerPlaybackStateDidChange,
        object: musicplayer
            )
//        vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainPlayer")
//        self.addChild(vc!)
//        self.view.addSubview(vc.view)
//        vc.didMove(toParent: self)
//        vc.view.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: view.frame.height)
//        vc.minimize(completion: nil)
        musicplayersetup()
        
        let ob = NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerQueueDidChange,
            object: self.musicplayer, queue: OperationQueue.main) { n in
                self.musicplayerapi.monitorplayerqueuechange()
        }
        self.ob = ob

    }
//    @objc func userSwipedFromEdge(sender: UIScreenEdgePanGestureRecognizer) {
//        if sender.edges == .right {
//            print("It works!")
//        }
//    }
    override func viewDidAppear(_ animated: Bool) {
       // musicplayersetup()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(ob!)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("yooooy2")
        NotificationCenter.default.removeObserver(ob!)
        
        //navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    lazy var miniplayerview : MiniPlayer =
    {
        let inputcontainerview = MiniPlayer(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65))
        //inputcontainerview.backgroundColor = UIColor(named: "miniplayercolor")
        inputcontainerview.backgroundColor = .clear
        inputcontainerview.viewcontroller = self
        inputcontainerview.translatesAutoresizingMaskIntoConstraints = false
        return inputcontainerview
        
    }()
    
    lazy var playbutton : UIButton =
    {
           let button = UIButton()
           let config1 = UIImage.SymbolConfiguration(pointSize: 29)
           let image1 = UIImage(systemName: "play.circle.fill", withConfiguration: config1)
           button.setImage(image1, for: .normal)
           button.addTarget(self, action: #selector(playlistPlayButtonDidTap), for: .touchUpInside)
           button.tintColor = .white
           button.isUserInteractionEnabled = true
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
    }()
    
//    lazy var playlistname : EFAutoScrollLabel =
//    {
//        let name = EFAutoScrollLabel()
//        name.translatesAutoresizingMaskIntoConstraints = false
//        name.font = .systemFont(ofSize: 16)
//        name.textColor = .white
//        //name.tintColor =
//        name.textColor = UIColor(named: "Colorpink")
//
//
//        return name
//    }()

    func setupUI()
    {
        playlisttable.tableFooterView = UIView(frame: CGRect.zero)
//        self.view.addSubview(miniplayerview)
//        let guide = self.view.safeAreaLayoutGuide
//        self.miniplayerview.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
//        self.miniplayerview.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
//        self.miniplayerview.heightAnchor.constraint(equalToConstant: 65).isActive = true
//        self.miniplayerview.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
//        
        //playlistdescription.text = playlist?.value(forProperty: MPMediaPlaylistPropertyDescriptionText) as? String

        let totalIndices = (playlist?.items.count)! - 1 // We get this value one time instead of once per iteration.
        if playlist!.items.count != 0
        {
//            albumartwork.delegate    = self
//            albumartwork.dataSource  = self
            for arrayIndex in 0...totalIndices
            {
                reversedPlaylist.append((playlist?.items[totalIndices - arrayIndex])!)
            }
        }
        else
        {

//            let iv = UIImageView(image: UIImage(named: "defaultmusicimage"))
//            iv.contentMode = .scaleAspectFill
//            albumartwork.addSubview(iv)
//            iv.translatesAutoresizingMaskIntoConstraints = false
//            iv.topAnchor.constraint(equalTo: albumartwork.topAnchor).isActive = true
//            iv.bottomAnchor.constraint(equalTo: albumartwork.bottomAnchor).isActive = true
//            iv.widthAnchor.constraint(equalTo: albumartwork.widthAnchor).isActive = true
            
            
        }
        
        
  
        //self.albumartwork.translatesAutoresizingMaskIntoConstraints = false
        
        let overlay = UIView()
        //overlay.frame = CGRect(x: 0, y: 0, width: albumartwork.frame.width, height: albumartwork.frame.height)
        //overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .clear
        //overlay.backgroundColor =  UIColor.black.withAlphaComponent(0.55)
        contentView.addSubview(overlay)
        //overlay.topAnchor.constraint(equalTo: albumartwork.topAnchor).isActive = true
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = overlay.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor ]
        gradient.locations = [0.0, 1.0]
        //overlay.layer.insertSublayer(gradient, at: 0)
        descriptionbox.addSubview(playbutton)
        //descriptionbox.addSubview(playlistname)
        
        otherplaylistdata.isUserInteractionEnabled = false
        otherplaylistdata.textContainer.lineFragmentPadding = 0
        otherplaylistdata.textContainerInset = .zero
        
        
        NSLayoutConstraint.activate(
        [
            //playbutton.bottomAnchor.constraint(equalTo: descriptionbox.bottomAnchor, constant: -20),
            playbutton.rightAnchor.constraint(equalTo: descriptionbox.rightAnchor, constant: -20),
            playbutton.centerYAnchor.constraint(equalTo: descriptionbox.centerYAnchor)
//            playlistname.leftAnchor.constraint(equalTo: overlay.leftAnchor, constant: 8),
//            playlistname.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -20),
//            playlistname.heightAnchor.constraint(equalToConstant: 21),
//            playlistname.widthAnchor.constraint(equalTo: overlay.widthAnchor, constant: -50)
        ])
        
        if playlist?.value(forProperty: MPMediaPlaylistPropertyName) as? String != "" || playlist?.value(forProperty: MPMediaPlaylistPropertyDescriptionText) as? String != nil
        {
            //playlistname.text = playlist?.value(forProperty: MPMediaPlaylistPropertyName) as? String
            playlistdescriptiontext.text = playlist?.value(forProperty: MPMediaPlaylistPropertyName) as? String
            otherplaylistdata.text = playlist?.value(forProperty: MPMediaPlaylistPropertyDescriptionText) as? String
        }

        //print(playlist?.value(forProperty: MPMediaPlaylistPropertyDescriptionText) as? String)
        if playlist?.value(forProperty: MPMediaPlaylistPropertyName) as? String == "Recently Added"
        {
            isRecentlyAdded = true
        }
        let newsize = CGSize(width: test.frame.size.width / 2, height: test.frame.size.height / 2)
        let imageaaray = playlist!.artworkImageArray(size:newsize)
        if playlist!.items.count == 0
        {
            
            test.image = UIImage(named: "defaultmusicimage")
        }
        
        if imageaaray.count >= 4
        {
            let savedimage = GlobalReferences().retrieveImage(forKey: playlist?.value(forProperty: MPMediaPlaylistPropertyName) as! String)
            if  savedimage != nil
            {
                print("this image is saved")
                test.image = savedimage
            }
            else
            {
                print("image aint saved")
                
                let newImage = playlist?.collageImage(rect: test.frame, images: imageaaray)
                test.image = newImage
                GlobalReferences().store(image: newImage!, forKey: playlist!.value(forProperty: MPMediaPlaylistPropertyName) as! String)
            }
        }
        else if imageaaray.count < 4 && imageaaray.count > 0
        {
            test.contentMode = .scaleAspectFill
            test.image = playlist!.items[0].artwork?.image(at: test.frame.size)
        }
        
        
 
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        playlisttable.layer.removeAllAnimations()
        playlisttableheight.constant = playlisttable.contentSize.height
        descriptionboxheight.constant = otherplaylistdata.frame.height + 30
        contentviewheight.constant = playlisttable.contentSize.height + descriptionboxheight.constant + 450
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }

    }
    
    func registerChatViewCell()
    {
        let SongListCell = UINib(nibName: "SongListCell", bundle: nil)
        
        self.playlisttable.register(SongListCell, forCellReuseIdentifier: "SongListCell")
        
    }
    
    func musicplayersetup()
    {
        isRecentlyAdded = playlist?.value(forProperty: MPMediaPlaylistPropertyName) as? String == "Recently Added"
        if isRecentlyAdded
        {
            let collection = MPMediaItemCollection(items: reversedPlaylist)
            let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: collection)
            musicplayerapi.setQueueWithDescriptor(descriptor: descriptor)
        
            self.musicplayer.shuffleMode = MPMusicShuffleMode(rawValue: 1)!
        }
        else
        {
            let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: playlist!)
            musicplayerapi.setQueueWithDescriptor(descriptor: descriptor)
            self.musicplayer.shuffleMode = MPMusicShuffleMode(rawValue: 1)!
        }
        
        
    }
    
    @objc func playlistPlayButtonDidTap()
    {
        //musicplayersetup()
        musicplayerapi.play()
    }
    @objc func monitorplayerqueuechange()
       {

           //NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerQueueDidChange, object: nil)

               self.musicplayer.perform(queueTransaction: { (queue) in
                   
                                    print("cappppp",queue,queue.items)
                                    MainPlayerViewController.shared.queuarray = queue.items

                                })
                                { (queue, error) in


               //                   for i in queue.items
               //                   {
               //                       //print(i.title)
               //                   }
                                    print("citsaaa",self)
                                  if error != nil {
                                    print("nigga its bad",error!)
                                  }
                                   //self.lock = false
                                   //self.schedule()
                                   
                                   //self.performscheduled()
                                }


              // task 1

       }

    
    @objc func handleMusicPlayerControllerPlaybackStateDidChange()
    {
        let iscurrentlyplaying = musicplayer.playbackState.rawValue == 1

        DispatchQueue.main.async
        {
            for item in self.playlisttable.visibleCells as! [SongListCell]
            {
                if iscurrentlyplaying
                {
                    item.indicator.state = .playing
                }
                else
                {
                    item.indicator.state = .paused
                }
            }
        }
    }
    
    @objc func monitorNowPlaying()
    {
        
        //musicplayerapi.updateNowPlaying()
        //playlisttable.reloadData()
        //let iscurrentlyplaying = musicplayer.playbackState.rawValue == 1
        
       
        DispatchQueue.main.async
        {
            for item in self.playlisttable.visibleCells as! [SongListCell]
            {
                

                let comparingstring = item.songname.text
                if comparingstring == self.musicplayer.nowPlayingItem?.value(forProperty: MPMediaItemPropertyTitle) as? String
                {
                    item.nowplayinganimation.isHidden = false
                    
                }
                else
                {
                    item.nowplayinganimation.isHidden = true
                   
                    
                }
            }
        }
        
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
    //        if scrollView.
       
       
        if scrollView.contentOffset.y > descriptionbox.frame.origin.y
        {
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
                self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(1)
                self.navigationItem.title = self.playlist?.value(forProperty: MPMediaPlaylistPropertyName) as? String
                
            }, completion: nil)
        }
        else
        {
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
                self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(1)
                self.navigationItem.title = ""
                
            }, completion: nil)
        }
    }
    override var childForStatusBarHidden: UIViewController?
    {
        return vc
    }
//    func textViewDidChange(_ textView: UITextView)
//    {
//        
//        let fixedWidth = textView.frame.size.width
//        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        var newFrame = textView.frame
//        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        textView.frame = newFrame
//        print("hig",newSize)
//    }
     

}

extension PlaylistViewController
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 58
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell") as? SongListCell
        var item = MPMediaItem()
        let size = cell?.songartwork.frame.size
        if isRecentlyAdded
        {
            item = reversedPlaylist[indexPath.row]
        }
        else
        {
            item = (playlist?.items[indexPath.row])!
        }
        
        
        
        cell?.songname.text = item.value(forProperty: MPMediaItemPropertyTitle) as? String
        cell?.songartist.text = item.value(forProperty: MPMediaItemPropertyArtist) as? String
        
        if let image = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
        {
            cell?.songartwork.image = image.image(at: size!)
        }
        else
        {
            cell?.songartwork.image = UIImage(named: "defaultmusicimage")
        }
        
        if item == musicplayer.nowPlayingItem
        {
            cell?.nowplayinganimation.isHidden = false
            cell?.indicator.state = .playing
        }
        else
        {
            cell?.nowplayinganimation.isHidden = true
        }
        
        
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        var item = MPMediaItem()
        //let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell") as? SongListCell
        
        
        
        if isRecentlyAdded
        {
            item = reversedPlaylist[indexPath.row]
            //musicplayersetup()
            musicplayerapi.setNowPlaying(item: item)
        }
        else
        {
            item = (playlist?.items[indexPath.row])!
            //musicplayersetup()
            musicplayerapi.setNowPlaying(item: item)
        }
        //cell?.nowplayinganimation.isHidden = false
        
//        let cell = playlisttable!.cellForRow(at: indexPath) as? SongListCell
//        cell?.nowplayinganimation.isHidden = false
        musicplayerapi.play()
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
//    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        
//        
//        var item = MPMediaItem()
//       
//        if isRecentlyAdded
//        {
//            item = reversedPlaylist[indexPath.row]
//        }
//        else
//        {
//            item = (playlist?.items[indexPath.row])!
//            
//        }
//        var albumarray = [MPMediaItem]()
//        let albumquery = MPMediaQuery.albums()
//        for album in (albumquery.items)!
//        {
//            if album.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String == item.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String && album.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String == item.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String
//            {
//                
//                albumarray.append(album)
//               
//            }
//        }
////        let viewalbumaction = musicplayerapi.viewalbmmenuaction(albumarray: albumarray, viewcontroller: self)
//        let upnextaction = musicplayerapi.addupnextmenuaction(item: item, album: nil)
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
//
//            var img = UIImage()
//            if let image = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
//            {
//                img = image.image(at: self.view.frame.size)!
//            }
//            else
//            {
//                img = UIImage(named: "defaultmusicimage")!
//            }
//            
//            return PreviewViewController(image: img)
//        }){ suggestedActions in
//               return UIMenu(title: "", children: [viewalbumaction, upnextaction])
//           }
//       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let backItem = UIBarButtonItem()
        //let back = UIBarButtonItem
        //backItem.title = "Home"
        
        //backItem.image = UIImage(systemName: "arrow.left")
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "albumsegue"
        {
            if let destinationVC = segue.destination as? AlbumViewController
            {
                if let album = sender as? [MPMediaItem]?
                {
                    destinationVC.album = album!
                }
                
            }
             
        }
    }

    
    
}
extension PlaylistViewController
{
 
}

