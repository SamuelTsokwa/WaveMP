//
//  MusicPlayerControlApi.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-06.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import Foundation
import MediaPlayer
import SPAlert
import NotificationCenter

class MusicPlayerControl
{
    var musicplayer = MPMusicPlayerController.applicationQueuePlayer
    var timer = Timer()
    var miniplayer : MiniPlayer?
    var mainplayercontrol : MainPlayerControls?
    var mainplayer : MainPlayerViewController?
    var list = [SongListCell]()
    var lock = false
    var count = 0
    var listofNotifications = [Notification]()
    let serialQueue = DispatchQueue(label: "com.queue.Serial")
    



    @objc func playmusic()
    {
        
        if musicplayer.playbackState.rawValue == 2 || musicplayer.playbackState.rawValue == 0
        {
            musicplayer.prepareToPlay()
            musicplayer.play()
            
        }
        else
        {
            musicplayer.pause()
        }
    }
    @objc func play()
    {
        musicplayer.prepareToPlay()
        musicplayer.play()
        
    }
    
    @objc func playnext()
    {
        musicplayer.skipToNextItem()
        
    }
    
    @objc func playprevious()
    {
        if Float(musicplayer.currentPlaybackTime) < 10.0 || Float(musicplayer.currentPlaybackTime) == 0.0
        {
            
            musicplayer.skipToPreviousItem()
        }
        
        else
        {
            musicplayer.skipToBeginning()
        }
    }
    
    @objc func repeatSong()
    {
        musicplayer.repeatMode = .one
    }
    
    @objc func addUpNext(item : MPMediaItem?, album : [MPMediaItem]?)
    {
        var temp = [MPMediaItem]()
        var coll = MPMediaItemCollection(items: temp)
        
        if album != nil
        {
            coll = MPMediaItemCollection(items: album!)
        }
        else
        {
            temp.append(item!)
            coll = MPMediaItemCollection(items: temp)
        }
        
        let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: coll)
        
        musicplayer.perform(queueTransaction: { (queue) in
            self.setQueueWithDescriptor(descriptor: descriptor)
            queue.insert(descriptor, after: self.musicplayer.nowPlayingItem!)
        }) { (queue, err) in
            if err != nil
            {
                print(err)
            }
        }
        //musicplayer.prepend(descriptor)
    }
    func viewalbmmenuaction(albumarray : [MPMediaItem], navigationController : UINavigationController) ->
        UIAction
    {
        let viewalbum = UIAction(title: "View Album", image: nil)
        { action in
            
            let pl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newPlaylist") as! NewPlaylistViewController
            pl.album = albumarray

            navigationController.pushViewController(pl, animated: true)
            
            
        }

         return viewalbum
    }
    
    func addupnextmenuaction(item : MPMediaItem?, album : [MPMediaItem]?) -> UIAction {
        let addnext = UIAction(title: "Add Next", image: nil)
        { action in
            if album != nil
            {
                MusicPlayerControl.init().addUpNext(item: nil, album: album)
                Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false)
                { (timer) in
                    SPAlert.present(title: "Added to your queue", preset: .done)
                }

            }
            else
            {
                MusicPlayerControl.init().addUpNext(item: item!, album: nil)
                Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false)
                { (timer) in
                    SPAlert.present(title: "Added to your queue", preset: .done)
                }
            }
           
        }
            
        

         return addnext
    }
    
    func updateUI()
    {
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self , selector: #selector(self.timerFired(_:)), userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
        
//        NotificationCenter.default.addObserver(
//        self,
//        selector: #selector(monitorplayerqueuechange),
//        name: .MPMusicPlayerControllerQueueDidChange,
//        object: nil
//            )
        //NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerQueueDidChange, object: nil)
        
        
    }
    @objc func timerFired(_ timer: Timer)
    {
        let nowplayingitem = musicplayer.nowPlayingItem
        let albumcoversize = miniplayer?.albumcover.frame.size
        //let mainartworksize = mainplayer?.artwork.frame.size
        
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        let config1 = UIImage.SymbolConfiguration(pointSize: 60)
        
        
        if musicplayer.playbackState.rawValue == 1
        {
            let image = UIImage(systemName: "pause.fill",withConfiguration: config)
            miniplayer?.playbutton.setImage(image, for: .normal)
            let image1 = UIImage(systemName: "pause.circle.fill", withConfiguration: config1)
            mainplayercontrol?.playbutton.setImage(image1, for: .normal)
        }
        else
        {
            let image = UIImage(systemName: "play.fill",withConfiguration: config)
            miniplayer?.playbutton.setImage(image, for: .normal)
            let image1 = UIImage(systemName: "play.circle.fill", withConfiguration: config1)
            mainplayercontrol?.playbutton.setImage(image1, for: .normal)
        }
        
        if musicplayer.nowPlayingItem != nil
        {
            if let minisongartwork: MPMediaItemArtwork = nowplayingitem?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
            {
                miniplayer?.albumcover.image = minisongartwork.image(at: albumcoversize!)
//                mainplayer?.artwork.image = minisongartwork.image(at: mainplayer)
                //MainPlayerViewController.shared.artworkimage = minisongartwork.image(at: CGSize(width: 303, height: 200))!
                    //MainPlayerViewController.
            }
            else
            {
                miniplayer?.albumcover.image = UIImage(named: "defaultmusicimage")
               // mainplayer?.artwork.image = UIImage(named: "defaultmusicimage")
            }
                  
            miniplayer?.songtitle.text = nowplayingitem?.value(forProperty: MPMediaItemPropertyTitle) as? String
            miniplayer?.songartist.text = nowplayingitem?.value(forProperty: MPMediaItemPropertyArtist) as? String
            let trackDuration = nowplayingitem?.playbackDuration
            miniplayer?.miniprogressbar.maximumValue = Float(trackDuration!)
            miniplayer?.miniprogressbar.value = Float(musicplayer.currentPlaybackTime)
            UIView.animate(withDuration: 0.2) {
                self.mainplayercontrol?.songname.text = nowplayingitem?.value(forProperty: MPMediaItemPropertyTitle) as? String
                self.mainplayercontrol?.songartist.text = nowplayingitem?.value(forProperty: MPMediaItemPropertyArtist) as? String
            }
            

            mainplayercontrol?.slider.maximumValue = Float(trackDuration!)
            mainplayercontrol?.slider.value = Float(musicplayer.currentPlaybackTime)
            let remainingTimeInSeconds = musicplayer.nowPlayingItem!.playbackDuration - musicplayer.currentPlaybackTime
            mainplayercontrol?.timeelapsed.text = getFormattedTime(timeInterval: remainingTimeInSeconds)
            mainplayercontrol?.timeremaining.text = getFormattedTime(timeInterval: musicplayer.currentPlaybackTime)

        }
        
      
        
    }
    @objc func monitorplayerqueuechange()
    {

        //NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerQueueDidChange, object: nil)

            self.musicplayer.perform(queueTransaction: { (queue) in
                
                                 MainPlayerViewController.shared.queuarray = queue.items
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadmainplayer"), object: nil)

                             })
                             { (queue, error) in


            //                   for i in queue.items
            //                   {
            //                       //print(i.title)
            //                   }
                               if error != nil {
                               }
                                //self.lock = false
                                //self.schedule()

                             }


           // task 1

    }
    @objc func schedule()
    {
        
       // NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerQueueDidChange, object: nil)

        let date = Date()
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)
        print("xyz-scheduling",lock,minute,sec)
        if lock == true
        {
            print("xyz-currentlylocked")
            DispatchQueue.main.async {
                self.count += 1
            }
            
            //lock =
            //listofNotifications.append(notification)
            //lock
            
        }
        else
        {
            self.lock = true
            print("xyz-currentlyopened",lock)
            
            
            //musicplayer.perform(#selector(monitorplayerqueuechange), on: .main, with: nil, waitUntilDone: true)
            DispatchQueue.main.async {
               
                    
                    self.monitorplayerqueuechange()
                
                
            }
            
            
        }
        
    }
    func performscheduled()
    {
        print("xyz-doingscheduled")
        if count ==  0 {return}
        for _ in 0...count
        {
            monitorplayerqueuechange()
            self.count -= 1
        }
    }
    
    
    @objc func setQueueWithQuery(query: MPMediaQuery)
    {
        musicplayer.setQueue(with: query)
    }
    @objc func setQueueWithDescriptor(descriptor: MPMusicPlayerQueueDescriptor)
    {
        musicplayer.setQueue(with: descriptor)
    }
    
    @objc func setNowPlaying(item: MPMediaItem)
    {
        //musicplayer.nowPlayingItem = item
//        var temp = [MPMediaItem]()
//        temp.append(item)
//        let coll = MPMediaItemCollection(items: temp)
//        let descriptor : MPMusicPlayerQueueDescriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: coll)
//        setQueueWithDescriptor(descriptor: descriptor)
        musicplayer.nowPlayingItem = item
    }
       
    @objc func updateNowPlaying()
    {
        //arrayofplaylistsongs()
//        let nowplayingitem = musicplayer.nowPlayingItem
//        DispatchQueue.main.async {
//            for item in self.playlistview?.playlisttable.visibleCells as! [SongListCell]
//        {
//            if item.songname.text == nowplayingitem?.value(forProperty: MPMediaItemPropertyTitle) as? String
//            {
//                item.nowplayinganimation.isHidden = false
//            }
//        }
//        }
//        let has =  list.contains(where: { (cell) -> Bool in
//            return cell.songname.text == nowplayingitem?.value(forProperty: MPMediaItemPropertyTitle) as? String
//        })
//        if has
//        {
//
//        }
//        let p = list.filter { (cell) -> Bool in
//            return cell.songname.text == nowplayingitem?.value(forProperty: MPMediaItemPropertyTitle) as? String
//        }
//        p[0].nowplayinganimation.isHidden = false
        
    }
//    func arrayofplaylistsongs()
//    {
//        DispatchQueue.main.async {
//            for item in self.playlistview?.playlisttable.visibleCells as! [SongListCell]
//            {
//                self.list.append(item)
//            }
//        }
//        
//    }
    func printQueue()
    {
        self.musicplayer.perform(queueTransaction: { (queue) in
                             //print("cappppp",queue,queue.items)
                             MainPlayerViewController.shared.queuarray = queue.items

                         })
                         { (queue, error) in

                            
        //                   for i in queue.items
        //                   {
        //                       //print(i.title)
        //                   }
                           if error != nil {
                             print("nigga its bad",error!)
                           }
                            self.lock = false
                         }
    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

    @objc func scrubtrack()
    {
        musicplayer.currentPlaybackTime = TimeInterval(Float(mainplayercontrol!.slider.value))
    }
    
    func getFormattedTime(timeInterval: TimeInterval) -> String {
        let mins = timeInterval / 60
        let secs = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return ""
        }
        return "\(minsStr):\(secsStr)"
    }
    
    
}
