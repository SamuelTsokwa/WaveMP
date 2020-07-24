//
//  CustomTableViewCell.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-18.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
{
   
    

    var collectionView : UICollectionView!
    let cellIdentifier: String = "NowPlayingCell"


    override func layoutSubviews()
    {
        
        super.layoutSubviews()
       
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
    
        layout.itemSize = CGSize(width: bounds.width - 80, height: bounds.height - 80)
        //collectionView.collectionViewLayout = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let NowPlayingCell = UINib(nibName: "NowPlayingCell", bundle: nil)
        collectionView.register(NowPlayingCell, forCellWithReuseIdentifier: "NowPlayingCell")
        setupTableView()

    }
       
       func setupTableView() {

           addSubview(collectionView)
           collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
           collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
           collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
           collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.reloadData()
           //collectionView.isScrollEnabled = false
       }
 
}
extension CustomTableViewCell
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 5
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingCell", for: indexPath) as? NowPlayingCell
        cell?.artwork.image = UIImage(named: "defaultmusicimage")
        cell?.songname.text = "Test"
//
        return cell!
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 40, height: 40)
    }
}
