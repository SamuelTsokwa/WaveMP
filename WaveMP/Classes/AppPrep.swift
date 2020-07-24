//
//  AppPrep.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-26.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
class AppPrep
{
    let playlists = MPMediaQuery.playlists().collections
    func cacheImages()
    {
        var i = 0
        let size = CGSize(width: 24, height: 24)
        let size1 = CGSize(width: 375, height: 303)
        let half = CGSize(width: 375 / 2, height: 303 / 2)
        
            for item in self.playlists!
            {
                
                //let playlistartworklist = item.artworkImageArray(size: CGSize(width: 375 / 2 , height: 303 / 2))
                let playlistartworklist = item.artworkImageArray(size: size)
                let savedimage = GlobalReferences().retrieveImage(forKey: item.value(forProperty: MPMediaPlaylistPropertyName) as!  String + "min" )
//                let playlistartworklist1 = item.artworkImageArray(size: half)
//                let savedimage1 = GlobalReferences().retrieveImage(forKey: item.value(forProperty: MPMediaPlaylistPropertyName) as!  String)
//
            /**************************first****/
                if playlistartworklist.count > 0 && playlistartworklist.count < 4
                {
                
                    print("eijop1",item.value(forProperty: MPMediaPlaylistPropertyName) as! String)
                    //GlobalReferences().delete(image: savedimage!,forKey: item.value(forProperty: MPMediaPlaylistPropertyName) as! String  + "min")
//                    GlobalReferences().delete(image: savedimage!,forKey: item.value(forProperty: MPMediaPlaylistPropertyName) as! String  )
                }

                else
                {

                    if  savedimage != nil
                    {

                        print("row image already saved",i,playlists?.count,item.value(forProperty: MPMediaPlaylistPropertyPersistentID) as! String)
                    i += 1
//                                    GlobalReferences().delete(image: savedimage!,forKey: item.value(forProperty: MPMediaPlaylistPropertyName) as! String  + "min")
                //                    GlobalReferences().delete(image: savedimage!,forKey: item.value(forProperty: MPMediaPlaylistPropertyName) as! String)
                    }
                    else
                    {
                        print("row image not  saved yet ",i,playlists?.count,item.value(forProperty: MPMediaPlaylistPropertyPersistentID) )
                        i += 1
                        let playlistartwork = item.collageImage(rect: CGRect(x: 0, y: 0, width: 48 , height: 48), images: playlistartworklist)
//                        let playlistartwork = item.collageImage(rect: CGRect(x: 0, y: 0, width: size1.width , height: size1.height), images: playlistartworklist)
                        let key = item.value(forProperty: MPMediaPlaylistPropertyPersistentID) as! NSNumber
                        GlobalReferences().store(image: playlistartwork, forKey: key.stringValue  + "min")
                        //GlobalReferences().store(image: playlistartwork1, forKey: item.value(forProperty: MPMediaPlaylistPropertyName) as! String)

                    }
                }
                 /**************************first****/
                
                 /**************************2****/
//                if playlistartworklist1.count > 0 && playlistartworklist1.count < 4
//                {
//                //print("eijop1",item.value(forProperty: MPMediaPlaylistPropertyName) as! String)
//
//                }
//                else
//                {
//
//                        if  savedimage1 != nil
//                        {
//
//                        print("row image already saved",i,playlists?.count)
//                        i += 1
//                        //GlobalReferences().delete(image: savedimage1!,forKey: item.value(forProperty: MPMediaPlaylistPropertyName) as! String  )
//
//                        }
//                        else
//                        {
//                            print("row image not  saved yet ",i,playlists?.count)
//                            i += 1
//                            let playlistartwork1 = item.collageImage(rect: CGRect(x: 0, y: 0, width: size1.width , height: size1.height), images: playlistartworklist1)
//                            GlobalReferences().store(image: playlistartwork1, forKey: item.value(forProperty: MPMediaPlaylistPropertyName) as! String)
//
//                        }
//                  }
                 /**************************2****/
 
            }
        }
    
    
}
