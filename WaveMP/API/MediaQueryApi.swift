//
//  MediaQueryApi.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-06.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import Foundation
import MediaPlayer

//let playlists = MPMediaQuery.playlists()
//let allalbums = MPMediaQuery.albums().collections

class MediaQuery
{
    
    static let sharedInstance = MediaQuery()
    
    @objc dynamic let playlists = MPMediaQuery.playlists().collections
    @objc dynamic let allalbums = MPMediaQuery.albums().collections
    func getSpecificPlaylist(playlistname : String) -> MPMediaPlaylist?
    {
        
        for ni in playlists!
        {
            
            if ni.value(forProperty: MPMediaPlaylistPropertyName) as! String == playlistname
            {
                return ni as! MPMediaPlaylist 
            }
            
        }
        
        return nil
    }
    
}
