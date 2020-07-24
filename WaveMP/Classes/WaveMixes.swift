//
//  WaveMixes.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-16.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import Foundation
import MediaPlayer
import MobileCoreServices
import UserNotifications
import FirebaseFirestore

class WaveMixes
{
    let songs = MPMediaQuery.songs()
    let albums = MPMediaQuery.albums().collections
    let playlists = MPMediaQuery.playlists().collections
    let genres = MPMediaQuery.genres().collections
    let mediaqueries = MediaQuery.init()
    var dailyplaylist : MPMediaItemCollection? = nil
    
    
    func waveplaylist()
    {
//        print("genre")
//        for item in genres!
//        {
//            print(item.representativeItem?.genre, item.items.count)
//        }
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)

        var list = [MPMediaItem]()
        if components.weekday == 7
        {
            sundayMix()
        }
        else
        {
            for genre in genres!
            {
                if genre.representativeItem?.genre == "World"
                {
                    let temp = genre.items.shuffled()
                    for i in 0...3
                    {
                        list.append(temp[i])
                    }
                }
                if genre.representativeItem?.genre == "R&B/Soul"
                {
                    let temp = genre.items.shuffled()
                    for i in 0...3
                    {
                        list.append(temp[i])
                    }
                }
                if genre.representativeItem?.genre == "Hip-Hop/Rap"
                {
                    let temp = genre.items.shuffled()
                    for i in 0...3
                    {
                        list.append(temp[i])
                    }
                }
                if genre.representativeItem?.genre == "Afro-Pop"
                {
                    let temp = genre.items.shuffled()
                    for i in 0...3
                    {
                        list.append(temp[i])
                    }
                }
                if genre.representativeItem?.genre == "Pop"
                {
                    let temp = genre.items.shuffled()
                    for i in 0...3
                    {
                        list.append(temp[i])
                    }
                }
              
            }

            let playlistmetadata = MPMediaPlaylistCreationMetadata(name: "WavePlaylist")
            playlistmetadata.descriptionText = "Your daily WaveList.\nA carefully curated playlist for your daily pleasure."
            let lib = MPMediaLibrary()
            lib.getPlaylist(with: UUID(), creationMetadata: playlistmetadata)
            { (pl, err) in
                if err == nil
                {
                    pl?.add(list, completionHandler: nil)
                }
                else
                {
                    print("err",err!)
                }
            }
           
            
        }
        
    
    }
    
    func sundayMix()
    {
        var list = [MPMediaItem]()
        for genre in genres!
        {
            if genre.representativeItem?.genre == "Inspirational"
            {
                let temp = genre.items.shuffled()
                for i in 0...10
                {
                    list.append(temp[i])
                }
            }
            if genre.representativeItem?.genre == "Gospel"
            {
                let temp = genre.items.shuffled()
                for i in 0...10
                {
                    list.append(temp[i])
                }
            }
            
        }
        let playlistmetadata = MPMediaPlaylistCreationMetadata(name: "WavePlaylist")
        playlistmetadata.descriptionText = "Your daily WaveList.\nA carefully narrated playlist for your daily pleasure."
        let lib = MPMediaLibrary()
        let uid = UUID()
        lib.getPlaylist(with: uid, creationMetadata: playlistmetadata)
        { (pl, err) in
            if err == nil
            {
                pl?.add(list, completionHandler: nil)
            }
            else
            {
                print("err",err!)
            }
        }
                
    }
}
