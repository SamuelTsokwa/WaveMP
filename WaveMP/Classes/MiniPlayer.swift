//
//  MiniPlayer.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-06.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import EFAutoScrollLabel
import MarqueeLabel
//import LNPopupController

class MiniPlayer: UIView {
    static let sharedInstance = MiniPlayer()
    @objc dynamic var miniplayerobject = self
    
    

    var viewcontroller = UIViewController()
    
    let musicplayerapi = MusicPlayerControl.init()
    
    let playbutton : UIButton =
    {
        let play = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "play.fill", withConfiguration: config)
        play.setImage(image, for: .normal)
        play.tintColor = .white
        play.isUserInteractionEnabled = true
        play.translatesAutoresizingMaskIntoConstraints = false
        play.showsTouchWhenHighlighted = true
        return play
    }()

    let albumcover : UIImageView =
    {
        let imageview = UIImageView()
        //imageview.frame = CGRect(x: 0, y: 0, width: 55, height: 65)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let songtitle : MarqueeLabel =
    {
        let title = MarqueeLabel()
        title.font = .systemFont(ofSize: 16)
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let songartist : UILabel =
    {
        let artist = UILabel()
        artist.font = .systemFont(ofSize: 11)
        artist.textColor = .lightGray
        artist.translatesAutoresizingMaskIntoConstraints = false
        
        return artist
    }()
    
    
    
    let nextbutton : UIButton =
    {
        let next = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "forward.fill", withConfiguration: config)
        next.setImage(image, for: .normal)
        next.tintColor = .white
        next.isUserInteractionEnabled = true
        next.translatesAutoresizingMaskIntoConstraints = false
        next.showsTouchWhenHighlighted = true
        return next
    }()
    
    let miniprogressbar: UISlider =
    {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.white
        slider.maximumTrackTintColor = UIColor.clear
        slider.isContinuous = true
        slider.isEnabled = true
        slider.setThumbImage(UIImage(), for: .normal)
        return slider
    }()
    

    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        //
        
        //self.addGestureRecognizer(tap)
        //self.addGestureRecognizer(pan)
       setUpView()
        
        
    }
    
    func setUpView()
    {
            backgroundColor = .clear
                
            let blurEffect = UIBlurEffect(style: .systemThinMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(blurEffectView)
            
            let image = UIImage(named: "defaultmusicimage")
            self.albumcover.image = image
            self.albumcover.contentMode = .scaleAspectFit
            addSubview(albumcover)
            // album cover constraints
            NSLayoutConstraint.activate(
            [
                self.albumcover.leftAnchor.constraint(equalTo: leftAnchor),
                self.albumcover.widthAnchor.constraint(equalToConstant: 62),
                self.albumcover.heightAnchor.constraint(equalToConstant: 62)
                //self.albumcover.heightAnchor.constraint(equalTo: heightAnchor),
    //            self.albumcover.topAnchor.constraint(equalTo: topAnchor),
    //            self.albumcover.bottomAnchor.constraint(equalTo: bottomAnchor)

            ])

            
            
            self.songtitle.text = "Play song"
            addSubview(songtitle)
            // song name constrainst
            NSLayoutConstraint.activate(
            [
                self.songtitle.leftAnchor.constraint(equalTo: self.albumcover.rightAnchor, constant: 8),
                self.songtitle.topAnchor.constraint(equalTo: topAnchor, constant: 4),
                self.songtitle.widthAnchor.constraint(equalToConstant: 180)

            ])
            
            
            //self.songartist.text = "James Bred"
            addSubview(songartist)
            // song name constrainst
            NSLayoutConstraint.activate(
            [
                self.songartist.leftAnchor.constraint(equalTo: self.albumcover.rightAnchor, constant: 8),
                self.songartist.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
                self.songartist.widthAnchor.constraint(equalToConstant: 140)

            ])
            
            addSubview(nextbutton)
            // next button constrainst

            
            
            
    //        play.addTarget(self, action: #selector(player), for: .touchUpInside)
            addSubview(playbutton)
            // play button constrainst
            NSLayoutConstraint.activate(
            [
                self.playbutton.centerYAnchor.constraint(equalTo: centerYAnchor),
                self.playbutton.leftAnchor.constraint(equalTo: self.songtitle.rightAnchor, constant: 15),
                self.playbutton.widthAnchor.constraint(equalToConstant: 35),
                self.playbutton.heightAnchor.constraint(equalToConstant: 35),


            ])
            NSLayoutConstraint.activate(
            [
                self.nextbutton.leftAnchor.constraint(equalTo: self.playbutton.rightAnchor, constant: 20),
                self.nextbutton.centerYAnchor.constraint(equalTo: centerYAnchor),
                self.nextbutton.widthAnchor.constraint(equalToConstant: 35),
                self.nextbutton.heightAnchor.constraint(equalToConstant: 35),


            ])
            
            
            self.playbutton.addTarget(musicplayerapi, action: #selector(musicplayerapi.playmusic), for: .touchUpInside)
            self.nextbutton.addTarget(musicplayerapi, action: #selector(musicplayerapi.playnext), for: .touchUpInside)
            
            
            
            self.miniprogressbar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 3)
            addSubview(miniprogressbar)
            
            // mini progressbar constrainst
            NSLayoutConstraint.activate(
            [
                self.miniprogressbar.bottomAnchor.constraint(equalTo: bottomAnchor),
                self.miniprogressbar.heightAnchor.constraint(equalToConstant: 3),
                self.miniprogressbar.widthAnchor.constraint(equalTo: widthAnchor)
            ])
            
     
            musicplayerapi.miniplayer  = self
            musicplayerapi.updateUI()
                
                
                
                
                
    }
    @objc func tapdidtap()
    {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainPlayer") as! MainPlayerViewController
        viewcontroller.present(vc, animated: true, completion: nil)
        
    }
    
    
    
    
    
    required init?(coder: NSCoder)
    {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        setUpView()
    }
    
}
