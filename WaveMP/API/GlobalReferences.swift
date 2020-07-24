//
//  GlobalReferences.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-17.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

let WAVEPLAYLISTS = "waveplaylists"
let FAVOURITES = "favourites"

class GlobalReferences
{
    func store(image: UIImage, forKey key: String)
      {
         if let pngRepresentation = image.pngData()
         {
             
             if let filePath = filePath(forKey: key) {
                         do  {
                             try pngRepresentation.write(to: filePath,
                                                         options: .atomic)
                         } catch let err {
                             print("Saving file resulted in error: ", err)
                         }
                     }
         }
      }
    func delete(image: UIImage, forKey key: String)
         {
            if let pngRepresentation = image.pngData()
            {
                
                if let filePath = filePath(forKey: key) {
                            do  {
                                try FileManager.default.removeItem(at: filePath)
                            } catch let err {
                                print("Saving file resulted in error: ", err)
                            }
                        }
            }
         }
     func retrieveImage(forKey key: String) -> UIImage?
     {
         if let filePath = self.filePath(forKey: key),
             let fileData = FileManager.default.contents(atPath: filePath.path),
             let image = UIImage(data: fileData) {
             return image
         }
         return nil
     }
     func filePath(forKey key: String) -> URL?
     {
         let fileManager = FileManager.default
         guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
         
         return documentURL.appendingPathComponent(key + ".png")
     }

     
}
