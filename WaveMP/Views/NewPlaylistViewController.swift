//
//  NewPlaylistViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-07-19.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer
import EFAutoScrollLabel
import MarqueeLabel


class NewPlaylistViewController: UIViewController {

    
    @IBOutlet var overlayView: MyGradientView!
    var musicplayer = MPMusicPlayerController.applicationQueuePlayer
    let mediaqueries = MediaQuery()
    let musicplayerapi = MusicPlayerControl()
    @IBOutlet var descriptionBoxHeight: NSLayoutConstraint!
    @IBOutlet var mainContentViewHeight: NSLayoutConstraint!
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    @IBOutlet var mainContentView: UIView!
    @IBOutlet var mediaImage: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var descriptionBox: UIView!
    var tableViewHeightConstraint: NSLayoutConstraint!
    let tableView: UITableView =
    {
        let tableView = UITableView()

        
        tableView.backgroundColor = .clear
        
        tableView.tableFooterView = UIView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    lazy var playbutton : UIButton =
    {
           let button = UIButton()
           let config1 = UIImage.SymbolConfiguration(pointSize: 69)
           
           let image1 = UIImage(systemName: "play.circle.fill", withConfiguration: config1)
           button.setImage(image1, for: .normal)
           button.addTarget(self, action: #selector(playlistPlayButtonDidTap), for: .touchUpInside)
           button.tintColor = .white
           button.isUserInteractionEnabled = true
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
    }()
    var playlist : MPMediaItemCollection?
    let mediaName : MarqueeLabel =
    {
        let title = MarqueeLabel()
        title.font = .boldSystemFont(ofSize: 30)
        title.textColor = UIColor.logocolor!
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    let playlistDescription : UILabel =
    {
        let title = UILabel()
//        title.font = .boldSystemFont(ofSize: 30)
//        title.textColor = UIColor.logocolor!
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    let mediaDescription : UITextView =
    {
        let title = UITextView()
//        title.font = .boldSystemFont(ofSize: 30)
//        title.textColor = UIColor.logocolor!
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    var playlistDescriptionHeight: NSLayoutConstraint!
    var mediaDescriptionHeight: NSLayoutConstraint!
    var album : [MPMediaItem]!
    var reversedPlaylist = [MPMediaItem]()
    lazy var isRecentlyAdded  = playlist?.value(forProperty: MPMediaPlaylistPropertyName) as? String == "Recently Added"
    var ob : NSObjectProtocol?
    var statusBarFrame: CGRect!
    var isPlaylist = false
    var statusBarView : UIView!
    var currentItemAlbum : [MPMediaItem]!
    override func viewDidAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isOpaque = true
//        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(ob!)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(ob!)
        
        //navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            statusBarFrame = navigationController!.view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        statusBarView = UIView(frame: statusBarFrame)
        navigationController!.view.addSubview(statusBarView)
        let backItem = UIBarButtonItem()
        backItem.tintColor = UIColor.logocolor!
        navigationItem.backBarButtonItem = backItem
        setUpMedia()
        tableView.reloadData()
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        registerCell()
        constraints()
        
        registerObservers()
    }
    

    
    
    func setUpUI()
    {
//        contentView.addSubview(overlayView)
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        tableView.dataSource = self
        tableView.delegate = self
        scrollView.delegate = self
        mainContentView.addSubview(tableView)
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
//        tableViewHeightConstraint.constant = tableView.contentSize.height
//        contentViewHeight.constant = tableView.contentSize.height + 500
        tableViewHeightConstraint.isActive = true
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = mainContentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        descriptionBox.backgroundColor = .clear
        mainContentView.addSubview(blurEffectView)
        mainContentView.sendSubviewToBack(blurEffectView)
        mainContentView.backgroundColor = .clear
        mainContentView.clipsToBounds = true
        descriptionBox.clipsToBounds = true
        mainContentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        descriptionBox.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        descriptionBox.layer.cornerRadius = 14
        mainContentView.layer.cornerRadius = 14
        contentView.backgroundColor = .clear
        
        
        tableView.backgroundColor = .clear
        tableView.backgroundView?.backgroundColor = .clear
        overlayView.superview!.bringSubviewToFront(playbutton)
        contentView.bringSubviewToFront(mainContentView)
//        mainContentView.bringSubviewToFront(descriptionBox)
//        descriptionBox.bringSubviewToFront(playbutton)
        
//        playbutton.layer.zPosition = -1
        overlayView.addSubview(mediaName)
        contentView.addSubview(playbutton)
        contentView.bringSubviewToFront(playbutton)
        setUpMedia()
    }
    
    func setUpMedia()
    {
        descriptionBox.addSubview(mediaDescription)
        mediaDescription.textContainer.lineFragmentPadding = 0
        mediaDescription.textContainerInset = .zero
        mediaDescription.backgroundColor = .clear
        mediaDescription.isScrollEnabled = false
        if playlist != nil
            {
                let totalIndices = (playlist?.items.count)! - 1 // We get this value one time instead of once per iteration.
                if playlist!.items.count != 0
                {
 
                    for arrayIndex in 0...totalIndices
                    {
                        reversedPlaylist.append((playlist?.items[totalIndices - arrayIndex])!)
                    }
                }
//                descriptionBox.addSubview(playlistDescription)
                
                if playlist?.value(forProperty: MPMediaPlaylistPropertyName) as? String != "" || playlist?.value(forProperty: MPMediaPlaylistPropertyDescriptionText) as? String != nil
                {
                    mediaName.text = playlist?.value(forProperty: MPMediaPlaylistPropertyName) as? String
                    mediaName.font = .boldSystemFont(ofSize: 30)
                    mediaName.textColor = UIColor.logocolor!
                    mediaDescription.text = playlist?.value(forProperty: MPMediaPlaylistPropertyDescriptionText) as? String
                    mediaDescription.frame.size.height = mediaDescription.contentSize.height
                }
                
                let newsize = CGSize(width: mediaImage.frame.size.width / 2, height: mediaImage.frame.size.height / 2)
                let imageaaray = playlist!.artworkImageArray(size:newsize)
                if playlist!.items.count == 0
                {
                    
                    mediaImage.image = UIImage(named: "defaultmusicimage")
                }
                
                if imageaaray.count >= 4
                {
                    let savedimage = GlobalReferences().retrieveImage(forKey: playlist?.value(forProperty: MPMediaPlaylistPropertyName) as! String)
                    if  savedimage != nil
                    {
                        print("this image is saved")
                        mediaImage.image = savedimage
                    }
                    else
                    {
                        print("image aint saved")
                        
                        let newImage = playlist?.collageImage(rect: mediaImage.frame, images: imageaaray)
                        mediaImage.image = newImage
                        GlobalReferences().store(image: newImage!, forKey: playlist!.value(forProperty: MPMediaPlaylistPropertyName) as! String)
                    }
                }
                else if imageaaray.count < 4 && imageaaray.count > 0
                {
                    mediaImage.contentMode = .scaleAspectFill
                    mediaImage.image = playlist!.items[0].artwork?.image(at: mediaImage.frame.size)
                }
            }
            else
            {
               
                let font = UIFont.systemFont(ofSize: 12, weight: .light)
                let albumartist = (album[0].value(forProperty: MPMediaItemPropertyArtist) as? String)!
                let albumgenre = (album[0].value(forProperty: MPMediaItemPropertyGenre) as? String)!
                let formatterGet = DateFormatter()
                formatterGet.setLocalizedDateFormatFromTemplate("YYYY")
                formatterGet.locale = Locale(identifier: "en_US_POSIX")
                let albumreleasedate = formatterGet.string(from: (album[0].value(forProperty: MPMediaItemPropertyReleaseDate) as! Date))
                let attr1 : [NSAttributedString.Key : Any] = [NSAttributedString.Key.strokeWidth: -5.0,NSAttributedString.Key.foregroundColor: UIColor(named: "LogoColor")!, NSAttributedString.Key.strokeColor : UIColor.white]
                let attr2 : [NSAttributedString.Key : Any] = [NSAttributedString.Key.strokeWidth: -5.0,NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.strokeColor : UIColor.lightGray, NSAttributedString.Key.font : font ]
                
                let artist = NSAttributedString(string: albumartist, attributes: attr1)
                let genre = NSAttributedString(string: albumgenre, attributes: attr2)
                let releasedate = NSAttributedString(string: albumreleasedate, attributes: attr2)
                let dot = NSAttributedString(string: " • ", attributes: attr2)
                let newline = NSAttributedString(string: "\n")
                let emptystring = NSAttributedString(string: " ")
                let albuminfostring = NSMutableAttributedString()
                
                albuminfostring.append(artist)
                albuminfostring.append(newline)
                albuminfostring.append(emptystring)
                albuminfostring.append(newline)
                albuminfostring.append(genre)
                albuminfostring.append(dot)
                albuminfostring.append(releasedate)
                
                
                mediaName.text = album[0].value(forProperty: MPMediaItemPropertyAlbumTitle) as? String
                mediaDescription.attributedText = albuminfostring
                mediaDescription.frame.size.height = mediaDescription.contentSize.height
                if let minisongartwork: MPMediaItemArtwork = (album[0]).value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                {

                    mediaImage.image  = minisongartwork.image(at: CGSize(width: (mediaImage.bounds.size.width) , height: (mediaImage.bounds.size.height)))!
                }
            }
    }
    
    func constraints()
    {
        NSLayoutConstraint.activate([
           
//            contentViewHeightConstraint,
            tableView.topAnchor.constraint(equalTo: descriptionBox.bottomAnchor, constant: 20),
            tableView.widthAnchor.constraint(equalTo: mainContentView.widthAnchor),
//            playbutton.rightAnchor.constraint(equalTo: overlayView.rightAnchor, constant: -10),
//            playbutton.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            mediaName.leftAnchor.constraint(equalTo: overlayView.leftAnchor, constant: 5),
            mediaName.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            mediaName.rightAnchor.constraint(equalTo: overlayView.rightAnchor, constant: -5),
            playbutton.centerYAnchor.constraint(equalTo: descriptionBox.topAnchor, constant: 0),
            playbutton.rightAnchor.constraint(equalTo: descriptionBox.rightAnchor, constant: -5),
            mediaDescription.topAnchor.constraint(equalTo: descriptionBox.topAnchor, constant: 10),
            mediaDescription.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            mediaDescription.widthAnchor.constraint(equalToConstant: view.frame.width - 72),

            
        ])
        if playlist != nil
        {
             NSLayoutConstraint.activate([
//                mediaName.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 0),
                
//                playlistDescription.topAnchor.constraint(equalTo: descriptionBox.topAnchor, constant: 10),
//                playlistDescription.leftAnchor.constraint(equalTo: descriptionBox.leftAnchor, constant: 5),
//                playlistDescription.widthAnchor.constraint(equalToConstant: view.frame.width - 71),
//
                
                
            ])
        }
        else
        {
//            NSLayoutConstraint.activate([
//            //                mediaName.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 0),
//                mediaDescription.topAnchor.constraint(equalTo: descriptionBox.topAnchor, constant: 10),
//                mediaDescription.leftAnchor.constraint(equalTo: descriptionBox.leftAnchor, constant: 5),
//                mediaDescription.rightAnchor.constraint(equalTo: descriptionBox.rightAnchor, constant: 5),
//
//
//
//            ])
        }
    }
    
    
    func registerCell()
    {
        if playlist != nil
        {
            let SongListCell = UINib(nibName: "SongListCell", bundle: nil)
            tableView.register(SongListCell, forCellReuseIdentifier: "SongListCell")
        }
        
        else if album != nil
        {
            let SongVCCell = UINib(nibName: "SongVCCell", bundle: nil)
            tableView.register(SongVCCell, forCellReuseIdentifier: "SongVCCell")
        }
        
    }
     
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
        
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        
        tableView.layer.removeAllAnimations()
        if tableView.contentSize.height != 0
        {
            tableViewHeightConstraint.constant = tableView.contentSize.height
            descriptionBoxHeight.constant = mediaDescription.frame.height + 20
            mainContentViewHeight.constant = tableViewHeightConstraint.constant + descriptionBoxHeight.constant + 40
            contentViewHeight.constant = mainContentViewHeight.constant + mediaImage.frame.height + 150
//            mediaDescription.frame.size.height = mediaDescription.contentSize.height
            
//            if playlist != nil
//            {
////                descriptionBoxHeight.constant = playlistDescription.frame.height + 20
//            }
//            else if album != nil
//            {
//                descriptionBoxHeight.constant = mediaDescription.frame.height + 20
////                print(descriptionBoxHeight,mediaDescription.frame.height)
//            }
            UIView.animate(withDuration: 0.5)
            {
               self.updateViewConstraints()
            }
        }
        else
        {

//            searchResultLabel.isHidden = true
        }
            

    }
    func registerObservers()
    {
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
//        musicplayersetup()
        let ob = NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerQueueDidChange,
            object: self.musicplayer, queue: OperationQueue.main) { n in
                self.musicplayerapi.monitorplayerqueuechange()
        }
        self.ob = ob
    }
    
    func musicplayersetup()
    {
        if playlist != nil
        {
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
        else if album != nil
        {
            let collection = MPMediaItemCollection(items: album)
            let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: collection)
            musicplayerapi.setQueueWithDescriptor(descriptor: descriptor)
            self.musicplayer.shuffleMode = MPMusicShuffleMode(rawValue: 1)!
        }
        musicplayer.prepareToPlay()
        
    }
    
    @objc func playlistPlayButtonDidTap()
    {
        musicplayersetup()
        
        musicplayerapi.play()
    }
    @objc func monitorplayerqueuechange()
    {

           //NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerQueueDidChange, object: nil)

       self.musicplayer.perform(queueTransaction: { (queue) in   MainPlayerViewController.shared.queuarray = queue.items})
        { (queue, error) in
              if error != nil
              {
                print(error!)
              }
                          
        }


    }
    
    @objc func handleMusicPlayerControllerPlaybackStateDidChange()
    {
        let iscurrentlyplaying = musicplayer.playbackState.rawValue == 1

        DispatchQueue.main.async
        {
            if self.playlist != nil
            {
                for item in self.tableView.visibleCells as! [SongListCell]
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
            else if self.album != nil
            {
                for item in self.tableView.visibleCells as! [SongVCCell]
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
    }
    
    @objc func monitorNowPlaying()
    {
        
        //musicplayerapi.updateNowPlaying()
        //playlisttable.reloadData()
        //let iscurrentlyplaying = musicplayer.playbackState.rawValue == 1
        
       
        DispatchQueue.main.async
        {
            if self.playlist != nil
            {
                for item in self.tableView.visibleCells as! [SongListCell]
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
            else if self.album != nil
            {
                for item in self.tableView.visibleCells as! [SongVCCell]
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
        
        
    }

}
extension NewPlaylistViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 58
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if playlist != nil
            {
                return playlist!.count
            }
            return album.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if playlist != nil
            {
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
                
    //            cell?.contentView.backgroundColor = .clear
                
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongVCCell") as? SongVCCell
            let item = album[indexPath.row]
             
            let name = item.value(forProperty: MPMediaItemPropertyTitle) as? String
            let songnumber = indexPath.row + 1
            cell?.songname.text = name
            cell?.songnumber.text = String(songnumber)
            
             
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
            musicplayersetup()
            if playlist != nil
            {
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
//                musicplayersetup()
                musicplayerapi.play()
            }
            
            else
            {
                let item = album[indexPath.row]
                        
                //musicplayersetup()
                musicplayerapi.setNowPlaying(item: item)
                musicplayerapi.play()
            }
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            if playlist != nil
            {

                 var item = MPMediaItem()
                
                 if isRecentlyAdded
                 {
                     item = reversedPlaylist[indexPath.row]
                 }
                 else
                 {
                     item = (playlist?.items[indexPath.row])!
                     
                 }
                 var albumarray = [MPMediaItem]()
                 let albumquery = MPMediaQuery.albums()
                 for album in (albumquery.items)!
                 {
                     if album.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String == item.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String && album.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String == item.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String
                     {
                         
                         albumarray.append(album)
                        
                     }
                 }
                currentItemAlbum = albumarray
                let viewalbumaction = musicplayerapi.viewalbmmenuaction(albumarray: albumarray, navigationController: self.navigationController!)
                 let upnextaction = musicplayerapi.addupnextmenuaction(item: item, album: nil)
                 return UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in

                     var img = UIImage()
                     if let image = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
                     {
                         img = image.image(at: self.view.frame.size)!
                     }
                     else
                     {
                         img = UIImage(named: "defaultmusicimage")!
                     }
                     
                     return PreviewViewController(image: img)
                 }){ suggestedActions in
                        return UIMenu(title: "", children: [viewalbumaction, upnextaction])
                    }
            }
            
            let item = album[indexPath.row]
            
            let upnextaction = musicplayerapi.addupnextmenuaction(item: item, album: nil)
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                return UIMenu(title: "", children: [upnextaction])
            }
            
        }
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.preferredCommitStyle = .pop
        animator.addCompletion {
            
            let pl = self.storyboard!.instantiateViewController(withIdentifier: "newPlaylist") as! NewPlaylistViewController
            pl.album = self.currentItemAlbum
            self.navigationController?.pushViewController(pl, animated: true)
        }
    }
        
        


    
    
}
extension NewPlaylistViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 320
        {
//            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
////                self.navigationController?.navigationBar.alpha = 1
////                self.navigationController?.setStatusBar(backgroundColor: UIColor.logocolor!)
//                self.statusBarView?.backgroundColor = .black
//                self.navigationController?.navigationBar.barTintColor = .black
//                self.navigationController?.navigationBar.backgroundColor = .black
//
//
//
//            }, completion: nil)
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
                UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
                    self.statusBarView?.backgroundColor = .black
                    self.navigationController?.navigationBar.barTintColor = .black
                    self.navigationController?.navigationBar.backgroundColor = .black
                                
                                
                                
                            }, completion: nil)
            }, completion: { (true) in
                 if self.playlist != nil
                   {
                       self.navigationItem.title = self.playlist?.value(forProperty: MPMediaPlaylistPropertyName) as? String
                       
                   }
                   else if self.album != nil
                   {
                       self.navigationItem.title = self.album[0].value(forProperty: MPMediaItemPropertyAlbumTitle) as? String
                   }
            })

        }
        else
        {
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseIn, animations: {
//                self.navigationController?.setStatusBar(backgroundColor: .clear)
                self.statusBarView?.backgroundColor = .clear
                self.navigationController?.navigationBar.backgroundColor = .clear
                self.navigationController?.navigationBar.barTintColor = .clear
                self.navigationItem.title = nil
                
//                self.view.backgroundColor = .green
                
            }, completion: nil)
            
        }
    }
}
