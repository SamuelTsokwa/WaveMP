//
//  AlbumViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-07.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer
import EFAutoScrollLabel
class AlbumViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    
    @IBOutlet var descriptionboxheight: NSLayoutConstraint!
    @IBOutlet var albumartwork: UIImageView!

    @IBOutlet var descriptionitem2: UITextView!
    var vc : MainPlayerViewController!
    @IBOutlet var descriptionitem1: UILabel!
    @IBOutlet var descriptionbox: UIView!
    @IBOutlet var contentview: UIView!
    @IBOutlet var contentviewheight: NSLayoutConstraint!
    @IBOutlet var songtableheight: NSLayoutConstraint!
    @IBOutlet var songtable: UITableView!
    var musicplayer = MPMusicPlayerController.applicationQueuePlayer
    let mediaqueries = MediaQuery.init()
    let musicplayerapi = MusicPlayerControl.init()
    var album = [MPMediaItem]()
    var ob : NSObjectProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registercell()
        musicplayersetup()
        self.songtable.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)

        
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
        let ob = NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerQueueDidChange,
            object: self.musicplayer, queue: OperationQueue.main) { n in
                self.musicplayerapi.monitorplayerqueuechange()
        }
        self.ob = ob
        
    }
    override func viewDidAppear(_ animated: Bool) {
        musicplayersetup()
    }
    
    lazy var miniplayerview : MiniPlayer =
    {
        let inputcontainerview = MiniPlayer(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65))
        inputcontainerview.backgroundColor = .clear
        inputcontainerview.translatesAutoresizingMaskIntoConstraints = false
        inputcontainerview.viewcontroller = self
        return inputcontainerview
        
    }()
    lazy var playbutton : UIButton =
    {
        let button = UIButton()
        let config1 = UIImage.SymbolConfiguration(pointSize: 29)
        let image1 = UIImage(systemName: "play.circle.fill", withConfiguration: config1)
        button.setImage(image1, for: .normal)
        button.addTarget(self, action: #selector(albumPlayButtonDidTap), for: .touchUpInside)
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
       
//    lazy var albumname : EFAutoScrollLabel =
//    {
//
//        let name = EFAutoScrollLabel()
//        name.translatesAutoresizingMaskIntoConstraints = false
//        name.font = .systemFont(ofSize: 16)
//        name.textColor = .white
//           //name.tintColor =
//        name.textColor = UIColor(named: "Colorpink")
//
//
//        return name
//    }()
    
    func setupUI()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        songtable.tableFooterView = UIView(frame: CGRect.zero)
//        self.view.addSubview(miniplayerview)
//        let guide = self.view.safeAreaLayoutGuide
//        self.miniplayerview.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
//        self.miniplayerview.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
//        self.miniplayerview.heightAnchor.constraint(equalToConstant: 65).isActive = true
//        self.miniplayerview.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
//        
        self.albumartwork.translatesAutoresizingMaskIntoConstraints = false
         
        let overlay = UIView()
        overlay.frame = CGRect(x: 0, y: 0, width: albumartwork.frame.width, height: albumartwork.frame.height)
         //overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .clear
         //overlay.backgroundColor =  UIColor.black.withAlphaComponent(0.55)
        contentview.addSubview(overlay)
        overlay.topAnchor.constraint(equalTo: albumartwork.topAnchor).isActive = true
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = overlay.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor ]
        gradient.locations = [0.0, 1.0]
        //overlay.layer.insertSublayer(gradient, at: 0)
        descriptionbox.addSubview(playbutton)
        //descriptionbox.addSubview(albumname)
         
        descriptionitem2.isUserInteractionEnabled = false
        descriptionitem2.textContainer.lineFragmentPadding = 0
        descriptionitem2.textContainerInset = .zero
         
         NSLayoutConstraint.activate(
         [
             //playbutton.bottomAnchor.constraint(equalTo: descriptionbox.bottomAnchor, constant: -20),
             playbutton.rightAnchor.constraint(equalTo: descriptionbox.rightAnchor, constant: -20),
             playbutton.centerYAnchor.constraint(equalTo: descriptionbox.centerYAnchor)
//             albumname.leftAnchor.constraint(equalTo: overlay.leftAnchor, constant: 8),
//             albumname.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -20),
//             albumname.heightAnchor.constraint(equalToConstant: 21),
//             albumname.widthAnchor.constraint(equalTo: overlay.widthAnchor, constant: -50)
         ])
        let font = UIFont.systemFont(ofSize: 12, weight: .light)
        let albumartist = (album[0].value(forProperty: MPMediaItemPropertyArtist) as? String)!
        let albumgenre = (album[0].value(forProperty: MPMediaItemPropertyGenre) as? String)!
        let formatterGet = DateFormatter()
        formatterGet.setLocalizedDateFormatFromTemplate("YYYY")
        formatterGet.locale = Locale(identifier: "en_US_POSIX")
        let albumreleasedate = formatterGet.string(from: (album[0].value(forProperty: MPMediaItemPropertyReleaseDate) as! Date))
        let attr1 : [NSAttributedString.Key : Any] = [NSAttributedString.Key.strokeWidth: -5.0,NSAttributedString.Key.foregroundColor: UIColor(named: "LogoColor")!, NSAttributedString.Key.strokeColor : UIColor(named: "LogoColor")!]
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
        
        
        
        descriptionitem1.text = album[0].value(forProperty: MPMediaItemPropertyAlbumTitle) as? String
        descriptionitem2.attributedText = albuminfostring
        print()
         
        if let minisongartwork: MPMediaItemArtwork = (album[0]).value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
        {

            albumartwork.image  = minisongartwork.image(at: CGSize(width: (albumartwork.bounds.size.width) , height: (albumartwork.bounds.size.height)))!
        }
    }
    
    func registercell()
    {
        let SongVCCell = UINib(nibName: "SongVCCell", bundle: nil)
        
        self.songtable.register(SongVCCell, forCellReuseIdentifier: "SongVCCell")
    }
    
    @objc func albumPlayButtonDidTap()
    {
        musicplayerapi.play()
    }
    @objc func handleMusicPlayerControllerPlaybackStateDidChange()
    {
        let iscurrentlyplaying = musicplayer.playbackState.rawValue == 1
        DispatchQueue.main.async
        {
            for item in self.songtable.visibleCells as! [SongVCCell]
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
        
       
        DispatchQueue.main.async
        {
            for item in self.songtable.visibleCells as! [SongVCCell]
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
    
    func musicplayersetup()
    {
       
        let collection = MPMediaItemCollection(items: album)
        let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: collection)
        musicplayerapi.setQueueWithDescriptor(descriptor: descriptor)
        self.musicplayer.shuffleMode = MPMusicShuffleMode(rawValue: 1)!
       
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        songtable.layer.removeAllAnimations()
        songtableheight.constant = songtable.contentSize.height
        descriptionboxheight.constant = descriptionitem2.frame.height + 30
        contentviewheight.constant = songtable.contentSize.height + descriptionboxheight.constant + 450
        contentviewheight.constant = songtable.contentSize.height + 520
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.
        if scrollView.contentOffset.y > descriptionbox.frame.origin.y
        {
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
                self.navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(1)
                self.navigationItem.title = self.album[0].value(forProperty: MPMediaItemPropertyAlbumTitle) as? String
                
            }, completion: nil)
                   
        }
        else
        {
            navigationItem.title = nil
        }
    }
    override var childForStatusBarHidden: UIViewController?
    {
        return vc
    }
    

}
extension AlbumViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        album.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        let item = album[indexPath.row]
                
        //musicplayersetup()
        musicplayerapi.setNowPlaying(item: item)
        musicplayerapi.play()
        
                
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = album[indexPath.row]
        let upnextaction = musicplayerapi.addupnextmenuaction(item: item, album: nil)
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            return UIMenu(title: "", children: [upnextaction])
        }
    }

    
}
