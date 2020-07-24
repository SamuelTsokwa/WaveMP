//
//  WaveViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-06.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer
import UPCarouselFlowLayout


class WaveViewController: UIViewController {
    @IBOutlet var viewAll: UIButton!
    lazy var pl = storyboard!.instantiateViewController(withIdentifier: "newPlaylist") as! NewPlaylistViewController
    let songslist = MPMediaQuery.playlists().items
    let mediaqueries = MediaQuery.init()
    let musicplayerapi = MusicPlayerControl.init()
    @IBOutlet var wavecollectionview: UICollectionView!
    lazy var waveplaylist : MPMediaItemCollection? = mediaqueries.getSpecificPlaylist(playlistname: "WavePlaylist")
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        registercell()
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(reloadData),
          name: .MPMediaLibraryDidChange,
          object: nil
              )

    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        //view.backgroundColor = .red
        navigationItem.title = "WavePlaylist"
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [UIColor.clear.cgColor,UIColor.white.cgColor]
        gradient.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradient, at: 0)
        //navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    lazy var miniplayerview : MiniPlayer =
    {
        let inputcontainerview = MiniPlayer(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65))
        inputcontainerview.backgroundColor = UIColor(named: "miniplayercolor")
        inputcontainerview.backgroundColor = .clear
        inputcontainerview.viewcontroller = self
        inputcontainerview.translatesAutoresizingMaskIntoConstraints = false
        return inputcontainerview
        
    }()
    
    func setupUI()
    {

        let layout = UPCarouselFlowLayout()
        wavecollectionview.collectionViewLayout = layout
        layout.itemSize = CGSize(width: 220, height: 280)
        layout.spacingMode = .fixed(spacing: 30)
        layout.scrollDirection = .horizontal
        viewAll.addTarget(self, action: #selector(seguetowaveplaylist), for: .touchUpInside)
        
    }
    func registercell()
    {
        let NowPlayingCell = UINib(nibName: "NowPlayingCell", bundle: nil)
        self.wavecollectionview.register(NowPlayingCell, forCellWithReuseIdentifier: "NowPlayingCell")
        //self.waveplayliststableview.register(CustomTableViewCell.self, forCellReuseIdentifier: "SCell")
        
//        let CollectionTableViewCell = UINib(nibName: "CollectionTableViewCell", bundle: nil)
//        self.waveplayliststableview.register(CollectionTableViewCell, forCellReuseIdentifier: "tbcellid")
//
    }
    @objc func reloadData()
    {
//        let playlistmetadata = MPMediaPlaylistCreationMetadata(name: "WavePlaylist")
//        playlistmetadata.descriptionText = "Your daily WaveList.\nA carefully curated playlist for your daily pleasure."
//        let lib = MPMediaLibrary()
//        lib.getPlaylist(with: UUID(), creationMetadata: playlistmetadata)
//        { (pl, err) in
//            if err == nil
//            {
//                self.waveplaylist = pl!
//            }
//            else
//            {
//                WaveMixes().waveplaylist()
//            }
//        }
        wavecollectionview.reloadData()
    }
    @objc func seguetowaveplaylist()
    {
        pl.playlist = waveplaylist
        let backItem = UIBarButtonItem()
        backItem.tintColor = UIColor.logocolor!
        navigationItem.backBarButtonItem = backItem
        navigationController!.pushViewController(pl, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //wavetoplaylist
        let backItem = UIBarButtonItem()

        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "wavetoplaylist"
        {
            if let destinationVC = segue.destination as? PlaylistViewController
            {
                
                destinationVC.playlist = sender as? MPMediaItemCollection
            }
        }
    }

}
extension WaveViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        waveplaylist!.items.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let item =  waveplaylist!.items[indexPath.row]
        let cell = self.wavecollectionview.dequeueReusableCell(withReuseIdentifier: "NowPlayingCell", for: indexPath) as? NowPlayingCell
        let size = cell?.artwork.frame.size
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 220, height: 280)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        let collection = MPMediaItemCollection(items: reversedPlaylist)
        let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: waveplaylist!)
        musicplayerapi.setQueueWithDescriptor(descriptor: descriptor)
        musicplayerapi.setNowPlaying(item: waveplaylist!.items[indexPath.row]  )
        
        musicplayerapi.play()
    }
    
}
extension WaveViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let cell = waveplayliststableview.dequeueReusableCell(withIdentifier: "tbcellid", for: indexPath) as! CollectionTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SCell", for: indexPath) as! CustomTableViewCell
        print(cell)
        //cell.up
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
}
