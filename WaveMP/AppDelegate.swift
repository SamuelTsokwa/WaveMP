//
//  AppDelegate.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-06.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        UserPermission().musicpermission()
        Notifications().requestNotificationAuthorization()
//        WaveMixes().waveplaylist()
        //let nots = Notifications()
        UNUserNotificationCenter.current().delegate = self
//        Notifications().schedulePlaylistNotification()
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .lightGray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
        let tabbar = UITabBar.appearance()
        //tabbar.backgroundImage = UIImage()
        //tabbar.shadowImage = UIImage()
        tabbar.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tabbar.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabbar.addSubview(blurEffectView)
        let lib = MPMediaLibrary()
        lib.beginGeneratingLibraryChangeNotifications()
//        DispatchQueue.global(qos: .background).async{
//            //AppPrep().cacheImages()
//            Lyrics().GenuisApi()
//            
//        }
        
        
        
        
        

//        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationBarAppearace.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    


}
extension AppDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.identifier == "PlaylistNotification"
        {
            print("playii")
            WaveMixes().waveplaylist()
            
        
           
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "waveplaylist"), object: nil)
//            let windows =
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let viewController = storyboard.instantiateViewController(withIdentifier :"wavevc") as! WaveViewController
//            let navController = UINavigationController.init(rootViewController: viewController)
//
//               if let window = windows, let rootViewController = window.rootViewController {
//                   var currentController = rootViewController
//                   while let presentedController = currentController.presentedViewController {
//                       currentController = presentedController
//                    }
//                       currentController.present(navController, animated: true, completion: nil)
//               }
        }

        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

    }
}

