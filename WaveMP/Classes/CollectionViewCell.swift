//
//  CollectionViewCell.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-13.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MediaPlayer


class CollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {

    var tableView = UITableView()
    let cellIdentifier: String = "SongListCell"
    var array = [MPMediaItemCollection]()
    let playlistslist = MPMediaQuery.playlists().collections
    let albumlis = MPMediaQuery.albums().collections

    override func layoutSubviews() {
        super.layoutSubviews()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let SongListCell = UINib(nibName: "SongListCell", bundle: nil)
        tableView.register(SongListCell, forCellReuseIdentifier: "SongListCell")
        
        setupTableView()

    }
    
    func setupTableView() {

        addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        tableView.isScrollEnabled = false
    }

//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//        self.tableView.frame.size.height = self.tableView.contentSize.height
//
//    }

    func setarray(arr : [MPMediaItemCollection])
    {
        self.array = arr
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell =  tableView.dequeueReusableCell(withIdentifier: "SongListCell") as? SongListCell
        let size = cell?.songartwork.frame.size
        let item = array[indexPath.row]
        if array.count == playlistslist?.count
        {
            cell?.songname.text = item.value(forProperty: MPMediaPlaylistPropertyName) as? String
        }
        
        if array.count == albumlis?.count
        {
            let item = array[indexPath.row]
            
            cell?.songname.text = item.representativeItem?.albumTitle
            cell?.songartist.text = item.representativeItem?.albumArtist
            
            
            if let image = item.representativeItem?.artwork
            {
                cell?.songartwork.image = image.image(at: size!)
            }
            else
            {
                cell?.songartwork.image = UIImage(named: "defaultmusicimage")
            }
        }
        
        
        
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 58
    }
}
