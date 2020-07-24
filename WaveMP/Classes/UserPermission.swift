//
//  UserPermission.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-06.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import Foundation
import MediaPlayer

class UserPermission
{
    func musicpermission()
    {
        // initial authorization
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //self.openMusicLibrary()
            break
        case .notDetermined:
            MPMediaLibrary.requestAuthorization() { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        //self.openMusicLibrary()
                    }
                }
            }
            break
        case .denied:
            //show alert
            print("Please Allow Access to the Media & Apple Music from appliction setting.")
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)

            break
        case .restricted:
            break
        
        @unknown default:
            print("Please Allow Access to the Media & Apple Music from appliction setting.")
        }
    }
}

