//
//  MPViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-07-17.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer
import Firebase
import FirebaseFirestore

class MPViewController: UIViewController, UIScrollViewDelegate {
    
    var timer = Timer()
    let musicplayerapi = MusicPlayerControl.init()
    let mediaqueries = MediaQuery.init()
    static let shared = MPViewController()
    let lyricdb = Firestore.firestore().collection("Lyrics")
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
    
    var contentViewHeight: NSLayoutConstraint?
    let contentView : UIView =
    {
        let cv = UIView()
        cv.backgroundColor = .green
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    let upperView : UIView =
    {
        let cv = UIView()
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    let scrollView : UIScrollView =
    {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var collview: UICollectionView?
    var tableview : UITableView?
    var tableviewHeight: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
    }
    

    func setupUI()
    {
        let cvlayout = UICollectionViewFlowLayout()
        cvlayout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        cvlayout.scrollDirection = .horizontal
        
        collview = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200), collectionViewLayout: cvlayout)
        collview?.backgroundColor = .clear
//        collview?.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        collview?.translatesAutoresizingMaskIntoConstraints = false
        collview?.showsHorizontalScrollIndicator = false
        collview?.delegate = self
        collview?.dataSource = self
        collview!.isPagingEnabled = true
        collview?.isScrollEnabled = false
        tableview = UITableView()
        tableview!.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        tableview!.backgroundColor = .white
        tableview!.dataSource = self
        tableview!.delegate = self
//        tableview!.emptyDataSetSource = self
//        tableview!.emptyDataSetDelegate = self
        tableview!.tableFooterView = UIView()

        tableview!.translatesAutoresizingMaskIntoConstraints = false
        tableview!.isScrollEnabled = false
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.delegate = self
//
//        contentView.addSubview(upperView)
        contentView.addSubview(collview!)
//        contentView.addSubview(tableview!)
//        contentView.addSubview(miniplayerview)
//        contentView.addSubview(mainplayercontrols)
//        contentView.addSubview(fadeview)
//        contentView.addSubview(MainPlayerViewController.shared.lyricstextview)
        tableviewHeight = tableview!.heightAnchor.constraint(equalToConstant: 300)
        contentViewHeight = contentView.heightAnchor.constraint(equalToConstant: 0)
        contentViewHeight?.priority = UILayoutPriority(250)
        tableviewHeight?.priority = UILayoutPriority(250)
        tableviewHeight?.constant = 300
        tableviewHeight?.isActive = true
        constraints()
        
        print("cehcek tgus",scrollView.subviews)
                    
    }
    func constraints()
    {
        print(scrollView,scrollView.isScrollEnabled)
        let guide = view.safeAreaLayoutGuide
        collview?.backgroundColor = .orange
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            collview!.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 900),
            collview!.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            collview!.heightAnchor.constraint(equalToConstant: 300),
//            tableview!.topAnchor.constraint(equalTo: collview!.bottomAnchor, constant: 20),
//            tableview!.widthAnchor.constraint(equalTo: contentView.widthAnchor),
////            collview!.heightAnchor.constraint(equalToConstant: 99),
//            miniplayerview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            miniplayerview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            miniplayerview.heightAnchor.constraint(equalToConstant: 65),
//            miniplayerview.topAnchor.constraint(equalTo: contentView.topAnchor),
////            mainplayercontrols.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
////            mainplayercontrols.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            mainplayercontrols.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            mainplayercontrols.heightAnchor.constraint(equalToConstant: 260),
//            mainplayercontrols.bottomAnchor.constraint(equalTo: collview!.bottomAnchor),
//            upperView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            upperView.heightAnchor.constraint(equalToConstant: 67),
//            upperView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            fadeview.topAnchor.constraint(equalTo: upperView.bottomAnchor),
//            fadeview.bottomAnchor.constraint(equalTo: self.collview!.bottomAnchor),
//            fadeview.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
        ])
        
        
        //            businessesTableViewHeight!.isActive = true
        contentViewHeight!.isActive = true
        contentViewHeight!.constant = 3000
        print(contentViewHeight)
    }
    func registerCell()
    {
        let MainPlayerCollectionViewCell = UINib(nibName: "MainPlayerCollectionViewCell", bundle: nil)
        self.collview!.register(MainPlayerCollectionViewCell, forCellWithReuseIdentifier: "MainPlayerCollectionViewCell")
        
//        let SongListCell = UINib(nibName: "SongListCell", bundle: nil)
//        upnexttable.register(SongListCell, forCellReuseIdentifier: "SongListCell")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        
        tableview!.layer.removeAllAnimations()
        if tableview!.contentSize.height != 0
        {
//            searchResultLabel.isHidden = false
            tableviewHeight!.constant = tableview!.contentSize.height
            contentViewHeight!.constant = tableview!.contentSize.height + view.frame.height
//            businessesTableViewHeight!.isActive = true
            contentViewHeight!.isActive = true
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
    
}

extension  MPViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
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

        let cell = collview!.dequeueReusableCell(withReuseIdentifier: "MainPlayerCollectionViewCell", for: indexPath) as? MainPlayerCollectionViewCell

        let size = CGSize(width: view.frame.width, height: view.frame.height)
        if MainPlayerViewController.shared.queuarray.count != 0
        {
            item = MainPlayerViewController.shared.queuarray[indexPath.row]
        }
        else
        {
            cell?.artwork.image = UIImage(named: "defaultmusicimage")
        }
        cell?.artwork.image = item.artwork?.image(at: size)

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
extension MPViewController : UITableViewDelegate, UITableViewDataSource
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
