//
//  SongVCCell.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-08.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import EFAutoScrollLabel
import ESTMusicIndicator


class SongVCCell: UITableViewCell {

    @IBOutlet var songnumber: UILabel!
    @IBOutlet var songname: UILabel!
    let indicator = ESTMusicIndicatorView.init(frame: CGRect.zero)
    @IBOutlet var nowplayinganimation: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        nowplayinganimation.clipsToBounds = true
        nowplayinganimation.translatesAutoresizingMaskIntoConstraints = false
        nowplayinganimation.layer.masksToBounds = true
        
        indicator.tintColor = UIColor(named: "LogoColor")
        indicator.sizeToFit()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        nowplayinganimation.addSubview(indicator)
        //indicator.state = .playing
        

        // Configure the view for the selected state
    }
    
}
