//
//  MainPlayerViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-26.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer
import Firebase
import FirebaseFirestore
import LNPopupController

class MainPlayerViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    var timer = Timer()

    @IBOutlet var upnexttableviewwidthconstraint: NSLayoutConstraint!
    @IBOutlet var upnexttableheightconstraint: NSLayoutConstraint!
    @IBOutlet var upnexttable: UITableView!
    var temprecg : UIPanGestureRecognizer?
    @IBOutlet var upperview: UIView!
    @IBOutlet var collview: UICollectionView!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentviewheightconstarint: NSLayoutConstraint!
    let musicplayerapi = MusicPlayerControl.init()
    let mediaqueries = MediaQuery.init()
    static let shared = MainPlayerViewController()
    let lyricdb = Firestore.firestore().collection("Lyrics")
    @objc dynamic var queuarray = [MPMediaItem]()
    let closeThresholdHeight: CGFloat = UIScreen.main.bounds.height - (49 + 65)
    let openThreshold: CGFloat = UIScreen.main.bounds.height - 200
    let closeThreshold = UIScreen.main.bounds.height - (49 + 65) // same value as closeThresholdHeight
    var isstatusbar = false
    var panGestureRecognizer: UIPanGestureRecognizer?
    var animator: UIViewPropertyAnimator?
    private var lockPan = false
    var isLyricShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setupUI()
        registerCell()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "reloadmainplayer"), object: nil)
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(monitorNowPlaying),
        name: .MPMusicPlayerControllerNowPlayingItemDidChange,
        object: nil
            )
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(handleMusicPlayerControllerPlaybackStateDidChange),
        name: .MPMusicPlayerControllerPlaybackStateDidChange,
        object: musicplayerapi.musicplayer
            )
        
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        //hidesBottomBarWhenPushed = true
        super.viewWillAppear(animated)
        musicplayerapi.monitorplayerqueuechange()
        
        
    }

    lazy var mainplayercontrols : MainPlayerControls =
    {
        let inputcontainerview = MainPlayerControls(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
        inputcontainerview.translatesAutoresizingMaskIntoConstraints = false
        //inputcontainerview.viewcontroller = self
        
        return inputcontainerview
    }()
    
    lazy var miniplayerview : MiniPlayer =
    {
        
        let inputcontainerview = MiniPlayer(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65))
        inputcontainerview.backgroundColor = .clear
        inputcontainerview.translatesAutoresizingMaskIntoConstraints = false
        inputcontainerview.viewcontroller = self
        
        return inputcontainerview
         
    }()
    
    let exitButton : UIButton =
    {
        let button = UIButton()
        //button.alpha = 0
 
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 7, bottom: 10, right: 7)
        return button
    }()
    
    let lyricbutton : UIButton =
    {
        let button = UIButton()

        //button.alpha = 0
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 7, bottom: 10, right: 7)
        return button
    }()
    
    let lyricstextview : UITextView =
    {
        let view = UITextView()
        view.textAlignment = .center
        view.isEditable = false
        view.text = ""
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.textColor = .white
        view.alpha = 0
        view.font = .systemFont(ofSize: 19, weight: .medium)

        return view
    }()
    
    let fadeview : UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.78)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
        
    }()
    
    func setupUI()
    {
        
        self.contentView.addSubview(mainplayercontrols)
        contentView.addSubview(fadeview)
        contentView.addSubview(MainPlayerViewController.shared.lyricstextview)
        musicplayerapi.mainplayer  = self
        musicplayerapi.updateUI()
        scrollview.isScrollEnabled = true
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.scrollDirection = .horizontal
        collview.isPagingEnabled = true
        collview.collectionViewLayout = layout


        exitButton.translatesAutoresizingMaskIntoConstraints = false
        lyricbutton.translatesAutoresizingMaskIntoConstraints = false
        upperview.translatesAutoresizingMaskIntoConstraints = false
        exitButton.layer.cornerRadius = 18
        exitButton.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        lyricbutton.layer.cornerRadius = 18
        lyricbutton.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        let config1 = UIImage.SymbolConfiguration(pointSize: 36)
        let image1 = UIImage(systemName: "chevron.down", withConfiguration: config1)
        exitButton.setImage(image1, for: .normal)
        exitButton.tintColor = UIColor.white
        exitButton.showsTouchWhenHighlighted = true
        let config2 = UIImage.SymbolConfiguration(pointSize: 36)
        let image2 = UIImage(systemName: "text.justifyleft", withConfiguration: config2)
        lyricbutton.setImage(image2, for: .normal)
        lyricbutton.tintColor = UIColor.white
        lyricbutton.showsTouchWhenHighlighted = true
        contentView.isUserInteractionEnabled = true
        
        upperview.addSubview(exitButton)
        upperview.addSubview(lyricbutton)
        upnexttable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        exitButton.leftAnchor.constraint(equalTo: upperview.leftAnchor, constant: 14),
        exitButton.centerYAnchor.constraint(equalTo: upperview.centerYAnchor),
        exitButton.widthAnchor.constraint(equalToConstant: 36),
        exitButton.heightAnchor.constraint(equalToConstant: 36),
        lyricbutton.rightAnchor.constraint(equalTo: upperview.rightAnchor, constant: -14),
        lyricbutton.centerYAnchor.constraint(equalTo: upperview.centerYAnchor),
        lyricbutton.widthAnchor.constraint(equalToConstant: 36),
        lyricbutton.heightAnchor.constraint(equalToConstant: 36),
        mainplayercontrols.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        mainplayercontrols.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        mainplayercontrols.heightAnchor.constraint(equalToConstant: 260),
        mainplayercontrols.bottomAnchor.constraint(equalTo: collview.bottomAnchor),
//        lyricstextview.topAnchor.constraint(equalTo: upperview.bottomAnchor, constant: 6),
//        lyricstextview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//        lyricstextview.bottomAnchor.constraint(equalTo: collview.bottomAnchor),
//        lyricstextview.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40),
        MainPlayerViewController.shared.lyricstextview.topAnchor.constraint(equalTo: upperview.bottomAnchor, constant: 6),
        MainPlayerViewController.shared.lyricstextview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        MainPlayerViewController.shared.lyricstextview.bottomAnchor.constraint(equalTo: collview.bottomAnchor),
        MainPlayerViewController.shared.lyricstextview.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40),
        fadeview.topAnchor.constraint(equalTo: self.upperview.bottomAnchor),
        fadeview.bottomAnchor.constraint(equalTo: self.collview.bottomAnchor),
        fadeview.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
        //upnexttable.widthAnchor.constraint(equalToConstant: 40),

        ])

        

        
        self.mainplayercontrols.backgroundColor = .clear
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        lyricbutton.addTarget(self, action: #selector(lyricbuttondidtap), for: .touchUpInside)

        upnexttableviewwidthconstraint.constant = view.frame.width - 40

        
        
        
    }
    @objc func reload()
    {
        collview.reloadData()
        upnexttable.reloadData()
//        upnexttable.layoutIfNeeded()
//        upnexttableheightconstraint.constant = upnexttable.contentSize.height
//        contentviewheightconstarint.constant = view.frame.height + upnexttable.contentSize.height + 100
        upnexttableheightconstraint.constant = CGFloat(58 * MainPlayerViewController.shared.queuarray.count)
        contentviewheightconstarint.constant = view.frame.height + upnexttableheightconstraint.constant + 100
        upnexttable.layoutIfNeeded()
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == collview
        {
            let temp = collview.visibleCells.first
            let index = collview.indexPath(for: temp!)?.row
            let item = MainPlayerViewController.shared.queuarray[index!]
            if musicplayerapi.musicplayer.nowPlayingItem == item
            {
                return
            }
            else
            {
                musicplayerapi.setNowPlaying(item: item)
                musicplayerapi.play()
            }

            
        }
    }

    
    func registerCell()
    {
        let MainPlayerCollectionViewCell = UINib(nibName: "MainPlayerCollectionViewCell", bundle: nil)
        self.collview.register(MainPlayerCollectionViewCell, forCellWithReuseIdentifier: "MainPlayerCollectionViewCell")
        
        let SongListCell = UINib(nibName: "SongListCell", bundle: nil)
        upnexttable.register(SongListCell, forCellReuseIdentifier: "SongListCell")
    }
    
    func showUpperviewControls()
    {
        UIView.animate(withDuration: 0.7) {
            self.lyricbutton.alpha = 1
            self.exitButton.alpha = 1
        }
        
    }

    
    @objc func handleMusicPlayerControllerPlaybackStateDidChange()
    {
        let iscurrentlyplaying = musicplayerapi.musicplayer.playbackState.rawValue == 1

        DispatchQueue.main.async
        {
            for item in self.upnexttable.visibleCells as! [SongListCell]
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
        let nowplayingitem = musicplayerapi.musicplayer.nowPlayingItem
        let index = musicplayerapi.musicplayer.indexOfNowPlayingItem
        let indexpath = IndexPath(item: index, section: 0)
        timer.invalidate()
        collview.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
        DispatchQueue.main.async
        {
            for item in self.upnexttable.visibleCells as! [SongListCell]
            {
                

                let comparingstring = item.songname.text
                let comparingstring2 = item.songartist.text
                if comparingstring == self.musicplayerapi.musicplayer.nowPlayingItem?.value(forProperty: MPMediaItemPropertyTitle) as? String && self.musicplayerapi.musicplayer.nowPlayingItem?.value(forProperty: MPMediaItemPropertyArtist) as? String == comparingstring2
                {
                    item.nowplayinganimation.isHidden = false
                    
                }
                else
                {
                    item.nowplayinganimation.isHidden = true
                   
                    
                }
            }
            for item in self.collview.visibleCells as! [MainPlayerCollectionViewCell]
            {
                
                if let artwork = nowplayingitem?.artwork
                {
                    print("tester4",nowplayingitem?.title)
                    let size = item.artwork.frame.size
                    item.artwork.image = artwork.image(at: size)
                }
                else
                {
                    item.artwork.image = UIImage(named: "defaultmusicimage")
                }
                self.collview.reloadData()
            }
        }
        if nowplayingitem?.title != nil && nowplayingitem?.artist != nil
        {
//            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            DispatchQueue.main.async {
                MainPlayerViewController.shared.lyricstextview.text = "Lyrics not available"
                let key = nowplayingitem!.title! + " " + nowplayingitem!.artist!
                let keystring = key.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
                let item = self.lyricdb.document(keystring)
                item.getDocument { (snapshot, err) in
                    if let document = snapshot, document.exists
                    {
                        if let data = document.data()
                        {
                            DispatchQueue.main.async
                            {
                                MainPlayerViewController.shared.lyricstextview.text = data[keystring] as? String
                               // print("ytryetuiuo",MainPlayerViewController.shared.lyricstextview.text)
                            }
                            
                        }

                    }
                    else
                    {
                        DispatchQueue.main.async
                        {
                            Lyrics().addlyrics(item: nowplayingitem!)
                        }
                        
                    }
                }
            }
            
        }


        
    }

    @objc func exit()
    {
        popupPresentationContainer?.closePopup(animated: true, completion: nil)
    }
    @objc func lyricbuttondidtap()
    {


        
        isLyricShowing = !isLyricShowing
        if isLyricShowing == true
        {
            UIView.animate(withDuration: 0.2)
            {
                MainPlayerViewController.shared.lyricstextview.alpha = 1
                self.mainplayercontrols.alpha = 0
                self.fadeview.alpha = 1
                self.upperview.backgroundColor = UIColor.black.withAlphaComponent(0.78)
            }

        }
        else
        {
            UIView.animate(withDuration: 0.3)
            {
                MainPlayerViewController.shared.lyricstextview.alpha = 0
                self.mainplayercontrols.alpha = 1
                self.fadeview.alpha = 0
                self.upperview.backgroundColor = .clear
            }
        }
        
    }
    @objc func update() {
        var progress = musicplayerapi.musicplayer.currentPlaybackTime / musicplayerapi.musicplayer.nowPlayingItem!.playbackDuration
        progress = progress * 1.3
            //player.currentTime / player.duration

        // Get the number of characters
        let characters = MainPlayerViewController.shared.lyricstextview.text.count
            //textView.text.characters.count

        // Calculate where to scroll
        let location = Double(characters) * progress
        //let location = Double(MainPlayerViewController.shared.lyricstextview.contentSize.height) * progress

        // Scroll the textView
        //print("jhgjhjy",location,progress)
        MainPlayerViewController.shared.lyricstextview.scrollRangeToVisible(NSRange(location: Int(location) , length: 10))
        //let contentOffset = CGPoint(x: 0.0, y: Double(MainPlayerViewController.shared.lyricstextview.contentSize.height) * progress)
         //MainPlayerViewController.shared.lyricstextview.setContentOffset(contentOffset, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }


}
extension  MainPlayerViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if MainPlayerViewController.shared.queuarray.count != 0
        {
            return MainPlayerViewController.shared.queuarray.count
        }
        else
        {
            return 1
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var item = MPMediaItem()
        
        let cell = collview.dequeueReusableCell(withReuseIdentifier: "MainPlayerCollectionViewCell", for: indexPath) as? MainPlayerCollectionViewCell

        let size = CGSize(width: view.frame.width, height: view.frame.height)
        if MainPlayerViewController.shared.queuarray.count != 0
        {
            item = MainPlayerViewController.shared.queuarray[indexPath.row]
            cell?.artwork.image = item.artwork?.image(at: size)
        }
        else
        {
            cell?.artwork.image = UIImage(named: "defaultmusicimage")
        }
        
            
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height + 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("hiii")
    }
    
}
extension MainPlayerViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if MainPlayerViewController.shared.queuarray.count != 0
        {
            return MainPlayerViewController.shared.queuarray.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell") as? SongListCell
        let size = cell?.songartwork.frame.size
        let item = MainPlayerViewController.shared.queuarray[indexPath.item]
        cell?.songartist.text = item.artist
        cell?.songname.text = item.title
        if let artwork = item.artwork
        {
            cell?.songartwork.image = artwork.image(at: size!)
        }
        else
        {
            cell?.songartwork.image = UIImage(named: "defaultmusicimage")
        }
        if item == musicplayerapi.musicplayer.nowPlayingItem
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
        let item = MainPlayerViewController.shared.queuarray[indexPath.item]
        musicplayerapi.setNowPlaying(item: item)
        musicplayerapi.play()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    
}
