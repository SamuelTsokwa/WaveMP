//
//  AlbumResultViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-11.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumResultViewController: UIViewController, UIScrollViewDelegate {

    lazy var pl = storyboard!.instantiateViewController(withIdentifier: "newPlaylist") as! NewPlaylistViewController
    var curritem : [MPMediaItem]? = nil
    var navController = UINavigationController()
    let mediaqueries = MediaQuery.init()
    let musicplayerapi = MusicPlayerControl.init()
    @IBOutlet var contentviewheight: NSLayoutConstraint!
    @IBOutlet var tvheight: NSLayoutConstraint!
    @IBOutlet var tableview: UITableView!
    var delegate : pagecontrollerprotocol?
    let listofallalbums = MPMediaQuery.albums().collections
    @objc dynamic var albumresultarr = [MPMediaItemCollection]()
    static let sharedInstance = AlbumResultViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        albumresultarr = listofallalbums!
        self.preferredContentSize.height = CGFloat(listofallalbums!.count * 58)
        //contentviewheight.constant = CGFloat(listofallalbums!.count * 58)
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 430, right: 0)
        self.tableview.contentInset = adjustForTabbarInsets
        self.tableview.scrollIndicatorInsets = adjustForTabbarInsets

        registerCell()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadtv), name: NSNotification.Name(rawValue: "load"), object: nil)

    }
    
    
   
    @objc func reloadtv()
    {
        tableview.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //tvheight.constant = CGFloat(listofallalbums!.count * 58)
    }
    func setupUI()
    {
 
    }
    
//    func updateDelegate()
//    {
//
//        let pageViewController = self.parent as! LibrarySearchPageViewController
//        self.delegate = pageViewController
//        //delegate?.getVCIndex(vc: self)
//        delegate?.getVCIndex(vc: self)
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        PVC.sharedInstance.childDidStartSCrolling = true
    }
    
    func registerCell()
    {
        let SongListCell = UINib(nibName: "SongListCell", bundle: nil)
        self.tableview.register(SongListCell, forCellReuseIdentifier: "SongListCell")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        tableview.translatesAutoresizingMaskIntoConstraints = false
//        tableview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: tableview.contentSize.height)
//        self.preferredContentSize.height = tableview.contentSize.height

        tvheight.constant = CGFloat(listofallalbums!.count * 58)
           
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
        print()

    }

}
extension AlbumResultViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AlbumResultViewController.sharedInstance.albumresultarr.count == 0
        {
            return listofallalbums!.count
        }
        else
        {
            return AlbumResultViewController.sharedInstance.albumresultarr.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell") as? SongListCell
        let size = cell?.songartwork.frame.size

        var item : MPMediaItemCollection
        if AlbumResultViewController.sharedInstance.albumresultarr.count == 0
        {
            item = albumresultarr[indexPath.row]
        }
        else
        {
            item = AlbumResultViewController.sharedInstance.albumresultarr[indexPath.row]
        }
        cell?.songname.text = item.representativeItem?.albumTitle
        cell?.songartist.text = item.representativeItem?.albumArtist
        cell?.nowplayinganimation.image = UIImage(systemName: "chevron.right.circle")
        
        if let image = item.representativeItem?.artwork
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
        return 58
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let av : AlbumViewController = storyboard?.instantiateViewController(identifier: "album") as! AlbumViewController
        var item : MPMediaItemCollection
        if AlbumResultViewController.sharedInstance.albumresultarr.count == 0
        {
            item = albumresultarr[indexPath.row]
        }
        else
        {
            item = AlbumResultViewController.sharedInstance.albumresultarr[indexPath.row]
        }
        pl.album = item.items
        let backItem = UIBarButtonItem()
        backItem.tintColor = UIColor.logocolor!
        navigationItem.backBarButtonItem = backItem
        navigationController!.pushViewController(pl, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?
    {
        var item : MPMediaItemCollection
        if AlbumResultViewController.sharedInstance.albumresultarr.count == 0
        {
            item = albumresultarr[indexPath.row]
            curritem = item.items
        }
        else
        {
            item = AlbumResultViewController.sharedInstance.albumresultarr[indexPath.row]
            curritem = item.items
        }
        let upnextaction = musicplayerapi.addupnextmenuaction(item: nil, album: item.items)
        return UIContextMenuConfiguration(identifier: nil, previewProvider:
        { () -> UIViewController? in

            var img = UIImage()
            if let image = item.representativeItem?.artwork
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
   
        pl.album = curritem!
        let backItem = UIBarButtonItem()
        backItem.tintColor = UIColor.logocolor!
        navigationItem.backBarButtonItem = backItem
        navigationController!.pushViewController(pl, animated: true)
    }
//
    
}
