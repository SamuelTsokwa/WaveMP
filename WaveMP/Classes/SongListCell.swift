//
//  SongListCell.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-06.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import ESTMusicIndicator
import MediaPlayer



class SongListCell: UITableViewCell {

    let mediaqueries = MediaQuery.init()
    let musicplayerapi = MusicPlayerControl.init()
    @IBOutlet var songartist: UILabel!
    @IBOutlet var songname: UILabel!
    @IBOutlet var nowplayinganimation: UIImageView!
    @IBOutlet var songartwork: UIImageView!
    let indicator = ESTMusicIndicatorView.init(frame: CGRect.zero)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        contentView.backgroundColor = .clear
//        backgroundColor = .clear
        songartwork.clipsToBounds = true
        songartwork.translatesAutoresizingMaskIntoConstraints = false
        songartwork.layer.masksToBounds = true
        nowplayinganimation.clipsToBounds = true
        nowplayinganimation.translatesAutoresizingMaskIntoConstraints = false
        nowplayinganimation.layer.masksToBounds = true
        songname.translatesAutoresizingMaskIntoConstraints = false
        songartist.translatesAutoresizingMaskIntoConstraints = false
        indicator.tintColor = UIColor(named: "LogoColor")
        indicator.sizeToFit()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        nowplayinganimation.addSubview(indicator)
        //indicator.state = .playing
     
        

        // Configure the view for the selected state
        
    }
//    func nextbutton() -> UIContextMenuConfiguration?
//    {
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (actions) -> UIMenu? in
//             let playbutton = UIAction(title: "Play next", image: nil)
//            { action in
//                //musicplayerapi.addUpNext(item: self)
//
//            }
//
//
//                          // Create other actions...
//
//                return UIMenu(title: "", children: [playbutton])
//        }
//    }
    
}
//extension SongVCCell:  addupnextdel
//{
//
//}
