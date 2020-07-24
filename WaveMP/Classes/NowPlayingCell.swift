//
//  NowPlayingCell.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-07.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import EFAutoScrollLabel
import ESTMusicIndicator


class NowPlayingCell: UICollectionViewCell {

    @IBOutlet var songartist: UILabel!
    @IBOutlet var songname: UILabel!
    @IBOutlet var artwork: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        artwork.clipsToBounds = true
        artwork.layer.masksToBounds = true
        artwork.translatesAutoresizingMaskIntoConstraints = false
        
    }

}
