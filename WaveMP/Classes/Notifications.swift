//
//  Notifications.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-16.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//


import MediaPlayer
import MobileCoreServices
import UserNotifications

class Notifications : NSObject, UNUserNotificationCenterDelegate
{
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationAuthorization()
    {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func schedulePlaylistNotification()
    {
       
        var date = DateComponents()
        date.hour = 22
        date.minute = 59

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "WaveMix"
        notificationContent.body = "Your daily Wavemix is ready !"
        notificationContent.sound = UNNotificationSound.default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10,
//                 repeats: false)
                 let request = UNNotificationRequest(identifier: "PlaylistNotification",
                 content: notificationContent,
                 trigger: trigger)
                 self.userNotificationCenter.add(request) { (error) in
                     if let error = error {
                        print("Notification Error: ", error.localizedDescription)
                     }
                     else{print("success")}
                 }

    }
    

  
}
extension Notifications
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        //let userInfo = response.notification.request.content.userInfo
        if response.notification.request.identifier == "PlaylistNotification"
        {
            //print("love",userInfo["waveplaylist"])
            print("hiiiii")
        }

        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
}

