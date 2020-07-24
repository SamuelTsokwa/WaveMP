//
//  MainPlayerControls.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-05-01.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import MarqueeLabel


class MainPlayerControls: UIView
{
    
    let musicplayerapi = MusicPlayerControl.init()

    let slider : UISlider =
    {
        let object = UISlider()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    let nextbutton : UIButton =
    {
        let object = UIButton()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    let playbutton : UIButton =
    {
        let object = UIButton()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    let moreoptions : UIButton =
    {
        let object = UIButton()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    let repeatoptions : UIButton =
    {
        let object = UIButton()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    let previousbutton : UIButton =
    {
        let object = UIButton()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    let songname : MarqueeLabel =
    {
        let object = MarqueeLabel()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    let songartist : MarqueeLabel =
    {
        let object = MarqueeLabel()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    let timeelapsed : UILabel =
    {
        let object = UILabel()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    let timeremaining : UILabel =
    {
        let object = UILabel()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    let upnext : UIImageView =
    {
        let object = UIImageView()
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        addSubview(songname)
        addSubview(songartist)
        addSubview(slider)
        addSubview(timeelapsed)
        addSubview(timeremaining)
        addSubview(previousbutton)
        addSubview(playbutton)
        addSubview(nextbutton)
        addSubview(moreoptions)
        addSubview(repeatoptions)
        //addSubview(upnext)
        
        musicplayerapi.mainplayercontrol = self
        musicplayerapi.updateUI()
        
        songname.font = .systemFont(ofSize: 20)
        songname.textColor = UIColor(named: "LogoColor")
        songname.type = .continuous
        songname.animationCurve = .easeInOut
        
        songartist.font = .systemFont(ofSize: 14)
        songartist.textColor = .lightGray
        
        let newimage = UIImage.fromRoundImage(size: CGSize(width: 16, height: 16), backgroundColor: UIColor.white)
        //let newimage = UIImage.from(color: .white)
        slider.setThumbImage(newimage, for: .normal)
        slider.setThumbImage(newimage, for: .highlighted)
        slider.setThumbImage(newimage, for: .focused)
        slider.minimumTrackTintColor = UIColor.lightGray
        slider.maximumTrackTintColor = UIColor.darkGray
        slider.isContinuous = true
        slider.isEnabled = true
        slider.isUserInteractionEnabled = true
        slider.addTarget(musicplayerapi, action: #selector(musicplayerapi.scrubtrack), for: .touchUpInside)
        
        timeremaining.textColor = .lightGray
        timeremaining.text = "00:00"
        timeremaining.font = .systemFont(ofSize: 12)
        
        timeelapsed.textColor = .lightGray
        timeelapsed.text = "00:00"
        timeelapsed.font = .systemFont(ofSize: 12)
        
        let config = UIImage.SymbolConfiguration(pointSize: 60)
        let image = UIImage(systemName: "play.circle.fill", withConfiguration: config)
        playbutton.setImage(image, for: .normal)
        playbutton.tintColor  = .white
        playbutton.addTarget(musicplayerapi, action: #selector(musicplayerapi.playmusic), for: .touchUpInside)
        
        let nextconfig = UIImage.SymbolConfiguration(pointSize: 25)
        let nextimage = UIImage(systemName: "forward.end.fill", withConfiguration: nextconfig)
        nextbutton.setImage(nextimage, for: .normal)
        nextbutton.tintColor  = .white
        nextbutton.addTarget(musicplayerapi, action: #selector(musicplayerapi.playnext), for: .touchUpInside)
        
        let prevconfig = UIImage.SymbolConfiguration(pointSize: 25)
        let previmage = UIImage(systemName: "backward.end.fill", withConfiguration: prevconfig)
        previousbutton.setImage(previmage, for: .normal)
        previousbutton.tintColor  = .white
        previousbutton.addTarget(musicplayerapi, action: #selector(musicplayerapi.playprevious), for: .touchUpInside)
        
        let menuconfig = UIImage.SymbolConfiguration(pointSize: 20)
        let menuimage = UIImage(systemName: "ellipsis", withConfiguration: menuconfig)
        moreoptions.setImage(menuimage, for: .normal)
        moreoptions.tintColor  = .white
        //previousbutton.addTarget(musicplayerapi, action: #selector(musicplayerapi.playprevious), for: .touchUpInside)
        
        let repeatimage = UIImage(systemName: "repeat", withConfiguration: menuconfig)
        repeatoptions.setImage(repeatimage, for: .normal)
        repeatoptions.tintColor  = .white
//
//        upnext.font = .boldSystemFont(ofSize: 14)
//        upnext.text = "Up Next"
        upnext.image = UIImage(systemName: "chevron.down")
        upnext.tintColor = .white


    }
    func setupConstraints()
    {
        NSLayoutConstraint.activate([
            songname.widthAnchor.constraint(equalToConstant: frame.width - 40),
            songname.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            songname.centerXAnchor.constraint(equalTo: centerXAnchor),
            songartist.widthAnchor.constraint(equalToConstant: frame.width - 40),
            songartist.topAnchor.constraint(equalTo: songname.bottomAnchor, constant: 5),
            songartist.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.widthAnchor.constraint(equalToConstant: frame.width - 40),
            slider.topAnchor.constraint(equalTo: songartist.bottomAnchor, constant: 15),
            timeremaining.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 5),
            timeremaining.leftAnchor.constraint(equalTo: slider.leftAnchor),
            timeelapsed.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 5),
            timeelapsed.rightAnchor.constraint(equalTo: slider.rightAnchor),
            playbutton.topAnchor.constraint(equalTo: timeremaining.bottomAnchor, constant: 5),
            playbutton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextbutton.topAnchor.constraint(equalTo: timeremaining.bottomAnchor, constant: 5),
            nextbutton.leftAnchor.constraint(equalTo: playbutton.rightAnchor, constant: 30),
            nextbutton.centerYAnchor.constraint(equalTo: playbutton.centerYAnchor),
            previousbutton.topAnchor.constraint(equalTo: timeremaining.bottomAnchor, constant: 5),
            previousbutton.rightAnchor.constraint(equalTo: playbutton.leftAnchor, constant: -30),
            previousbutton.centerYAnchor.constraint(equalTo: playbutton.centerYAnchor),
            moreoptions.topAnchor.constraint(equalTo: timeremaining.bottomAnchor, constant: 5),
            moreoptions.leftAnchor.constraint(equalTo: nextbutton.rightAnchor, constant: 40),
            moreoptions.centerYAnchor.constraint(equalTo: nextbutton.centerYAnchor),
            repeatoptions.topAnchor.constraint(equalTo: timeremaining.bottomAnchor, constant: 5),
            repeatoptions.rightAnchor.constraint(equalTo: previousbutton.leftAnchor, constant: -40),
            repeatoptions.centerYAnchor.constraint(equalTo: previousbutton.centerYAnchor),
//            upnext.centerXAnchor.constraint(equalTo: centerXAnchor),
//            upnext.topAnchor.constraint(equalTo: playbutton.bottomAnchor, constant:  20),
        
            
            
        
        ])
    }
    

}
