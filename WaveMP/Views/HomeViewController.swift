//
//  HomeViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-06.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer
import LNICoverFlowLayout
import UPCarouselFlowLayout
import DrawerView
import LNPopupController
import UIImageColors
import Pulley


class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    @IBOutlet var playlistName: UILabel!
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    @IBOutlet var allSongsCVHeight: NSLayoutConstraint!
    @IBOutlet var allSongsCV: UICollectionView!
    @IBOutlet var recentPlayedView: UIView!
    @IBOutlet var contentView: UIView!
    private var popupContentVC: MainPlayerViewController!
    private var mainplayer: MainPlayerViewController!
    var drawerView : DrawerView?
    var collview: UICollectionView?
    var observer : NSObjectProtocol?
    var animator: UIViewPropertyAnimator?
    @IBOutlet var nowplayingcarousel: UICollectionView!
    @IBOutlet var recentlyplayedbutton: UIButton!
    var reversedPlaylist = [MPMediaItem]()
    @IBOutlet var recentlyplayedview: UIView!
    let mediaqueries = MediaQuery.init()
    let musicplayerapi = MusicPlayerControl.init()
    static let sharedInstance = HomeViewController()
    lazy var pl = storyboard!.instantiateViewController(withIdentifier: "newPlaylist") as! NewPlaylistViewController
    lazy var playlist : MPMediaPlaylist = mediaqueries.getSpecificPlaylist(playlistname: "Recently Added")!
    lazy var recentlyPlayed : MPMediaPlaylist = mediaqueries.getSpecificPlaylist(playlistname: "Recently Played")!
    //lazy var playlist : MPMediaPlaylist = mediaqueries.getSpecificPlaylist(playlistname: "Recently Played")
    //lazy var playlist : MPMediaPlaylist = mediaqueries.getSpecificPlaylist(playlistname: "Gymflow")
    let sectionInsets = UIEdgeInsets(top: 20.0,left: 10.0,bottom: 20.0,right: 10.0)
    let itemsPerRow: CGFloat = 2
    var musicplayer = MPMusicPlayerController.applicationQueuePlayer
    var vc : MainPlayerViewController!
    var ob : NSObjectProtocol?
    
    
    let scrollView : UIScrollView =
    {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        super.viewWillAppear(animated)
        let custombar = storyboard!.instantiateViewController(withIdentifier: "cpbvc") as! CustomPopUpBarViewController
        custombar.view.backgroundColor = .clear
        custombar.miniPlayer.viewcontroller = self
        tabBarController!.popupBar.customBarViewController = custombar
        popupInteractionStyle = .snap
        popupBar.inheritsVisualStyleFromDockingView = true
        popupContentVC = (storyboard!.instantiateViewController(withIdentifier: "MainPlayer") as! MainPlayerViewController)
        tabBarController!.popupContentView.popupCloseButtonStyle = .none
        DispatchQueue.main.async {
            self.tabBarController!.presentPopupBar(withContentViewController: self.popupContentVC, animated: false, completion: nil)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        registerCell()

        
   
         musicplayersetup()
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(monitorNowPlaying),
        name: .MPMusicPlayerControllerNowPlayingItemDidChange,
        object: nil
            )

    }

    @objc func monitorplayerqueuechange()
    {


       self.musicplayer.perform(queueTransaction: { (queue) in   MainPlayerViewController.shared.queuarray = queue.items})
        { (queue, error) in
              if error != nil
              {
                print(error!)
              }
                          
        }


    }
    @objc func monitorNowPlaying()
    {
        if let nowplayingitem = musicplayer.nowPlayingItem
        {
            if let minisongartwork: MPMediaItemArtwork = nowplayingitem.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
            {
                let artworkimage = minisongartwork.image(at: CGSize(width: 20, height: 20))
                let colors = artworkimage!.getColors()
            
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    DispatchQueue.main.async {
                        self.view.backgroundColor = colors?.primary
                    }
                }, completion: nil)
                
//                    mainLabel.textColor = colors.primary
//                    secondaryLabel.textColor = colors.secondary
//                    detailLabel.textColor = colors.detail
            }
        }
        else
        {
           
        }
    
    }
    

    
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(ob!)
//        
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(ob!)
//        
//        //navigationController?.setNavigationBarHidden(false, animated: false)
//    }
//    deinit {
//        
//        NotificationCenter.default.removeObserver(ob!)
//    }
//    
    lazy var miniplayerview : MiniPlayer =
    {
        
        let inputcontainerview = MiniPlayer(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65))
        inputcontainerview.backgroundColor = .clear
        inputcontainerview.translatesAutoresizingMaskIntoConstraints = false
        inputcontainerview.viewcontroller = self
        
        return inputcontainerview
         
    }()
    lazy var bakgroundimage : UIImageView =
    {
        let imageview = UIImageView()
        return imageview
    }()
    
    func setupUI()
    {
  
        playlistName.text = recentlyPlayed.value(forProperty: MPMediaPlaylistPropertyName) as? String
        allSongsCV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        recentlyplayedbutton.addTarget(self, action: #selector(toRecentlyPlayed), for: .touchUpInside)
        let layout = UPCarouselFlowLayout()
        nowplayingcarousel.collectionViewLayout = layout
        layout.itemSize = CGSize(width: 290, height: 300)
        layout.spacingMode = .fixed(spacing: 15)
        layout.scrollDirection = .horizontal
        let layout1 = UICollectionViewFlowLayout()
        layout1.minimumLineSpacing = 35
        
        layout1.minimumInteritemSpacing = 5
        layout1.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 80, right: 10)
    
        allSongsCV.setCollectionViewLayout(layout1, animated: true)
//        constraints()
        
//        let newsize = CGSize(width: pl.mediaImage.frame.size.width / 2, height: pl.mediaImage.frame.size.height / 2)
//        let imageaaray = playlist.artworkImageArray(size:newsize)
//        if playlist.items.count == 0
//        {
//            pl.mediaImage.image = UIImage(named: "defaultmusicimage")
//        }
//        
//        if imageaaray.count >= 4
//        {
//            let savedimage = GlobalReferences().retrieveImage(forKey: playlist.value(forProperty: MPMediaPlaylistPropertyName) as! String)
//            if  savedimage != nil
//            {
//                print("this image is saved")
//                pl.mediaImage.image = savedimage
//            }
//            else
//            {
//                print("image aint saved")
//                
//                let newImage = playlist.collageImage(rect: pl.mediaImage.frame, images: imageaaray)
//                pl.mediaImage.image = newImage
//                GlobalReferences().store(image: newImage, forKey: playlist.value(forProperty: MPMediaPlaylistPropertyName) as! String)
//            }
//        }
//        else if imageaaray.count < 4 && imageaaray.count > 0
//        {
//            pl.mediaImage.contentMode = .scaleAspectFill
//            pl.mediaImage.image = playlist.items[0].artwork?.image(at: pl.mediaImage.frame.size)
//        }
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
        
    }
    
    func constraints()
    {
        
    }
    func musicplayersetup()
    {
          
        let totalIndices = (playlist.items.count) - 1 // We get this value one time instead of once per iteration.
        for arrayIndex in 0...totalIndices
        {
            reversedPlaylist.append((playlist.items[totalIndices - arrayIndex]))
        }
           
        let collection = MPMediaItemCollection(items: reversedPlaylist)
        let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: collection)
        musicplayerapi.setQueueWithDescriptor(descriptor: descriptor)
        self.musicplayer.shuffleMode = MPMusicShuffleMode(rawValue: 1)!
        
    }
    
    func registerCell()
    {
        let NowPlayingCell = UINib(nibName: "NowPlayingCell", bundle: nil)
        
        self.nowplayingcarousel.register(NowPlayingCell, forCellWithReuseIdentifier: "NowPlayingCell")
        self.allSongsCV.register(NowPlayingCell, forCellWithReuseIdentifier: "NowPlayingCell")
        
    }
    
    @objc func toRecentlyPlayed()
    {
        
        
        pl.playlist = playlist
        let backItem = UIBarButtonItem()
        backItem.tintColor = UIColor.logocolor!
        navigationItem.backBarButtonItem = backItem
        navigationController!.pushViewController(pl, animated: true)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
            
        allSongsCV.layer.removeAllAnimations()
        if allSongsCV.contentSize.height != 0
        {
            allSongsCVHeight.constant = allSongsCV.contentSize.height
            contentViewHeight.constant = allSongsCVHeight.constant + nowplayingcarousel.frame.height + 150
            UIView.animate(withDuration: 0.5)
            {
               self.updateViewConstraints()
            }
        }
        else
        {

        }
                

    }
    override var childForStatusBarHidden: UIViewController?
    {
        return vc
    }
    

   


}
extension HomeViewController
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count = 0
        if collectionView == nowplayingcarousel
        {
             count = reversedPlaylist.count
        }
        if collectionView == allSongsCV
        {
            count = 18
        }
        return count
        //
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
       {
            if collectionView == nowplayingcarousel
            {
                let cell = self.nowplayingcarousel.dequeueReusableCell(withReuseIdentifier: "NowPlayingCell", for: indexPath) as? NowPlayingCell
                 let size = cell?.artwork.frame.size
                 var item = MPMediaItem()
                 if collectionView == nowplayingcarousel
                 {
                      item =  reversedPlaylist[indexPath.row]
                 }
                 
                 
                
                 
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
                 
                 return cell!
            }
            let cell = self.allSongsCV.dequeueReusableCell(withReuseIdentifier: "NowPlayingCell", for: indexPath) as? NowPlayingCell
            let size = cell?.artwork.frame.size
            let item = recentlyPlayed.items[indexPath.row]
             

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
             
            return cell!
        
        
        
       }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        
        return 1
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == nowplayingcarousel
        {
            let collection = MPMediaItemCollection(items: reversedPlaylist)
            let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: collection)
            musicplayerapi.setQueueWithDescriptor(descriptor: descriptor)
            musicplayerapi.setNowPlaying(item: reversedPlaylist[indexPath.row])
        }
        if collectionView == allSongsCV
        {
           
            let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: recentlyPlayed)
            musicplayerapi.setQueueWithDescriptor(descriptor: descriptor)
            musicplayerapi.setNowPlaying(item: recentlyPlayed.items[indexPath.row])
        }
        musicplayerapi.play()
    }

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
      {
        
            if collectionView == nowplayingcarousel
            {
                return CGSize(width: 290, height: 300)
            }
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem , height: 230)
             
      }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if collectionView == allSongsCVHeight
//        {
//            return sectionInsets
//        }
//        return UIEdgeInsets.zero
//    }

}
extension HomeViewController:DrawerViewDelegate
{
}
