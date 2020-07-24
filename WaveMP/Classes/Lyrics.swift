//
//  waveplayer
//
//  Created by Samuel Tsokwa on 2020-02-14.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import Foundation
import SwiftSoup
import MediaPlayer
import Firebase
import FirebaseFirestore
let songs : [MPMediaItem] = MPMediaQuery.songs().items!
let wavedb = Firestore.firestore()
var count = 0

class Lyrics
{
    
    func GenuisApi()
    {
        for song in songs
        {
            guard var titlestring = song.title else{return }
            guard let artiststring = song.artist else{return }
            titlestring = parseTitleString(string: titlestring)
            var finaltitlestring = ""
            var finalartiststring = ""
            if titlestring.contains(" ")
            {
                finaltitlestring = titlestring.replacingOccurrences(of: " ", with: "%20")
            }
            else
            {
                finaltitlestring = titlestring
            }
            
            if artiststring.contains(" ")
            {
                finalartiststring = titlestring.replacingOccurrences(of: " ", with: "%20")
            }
            else
            {
                finalartiststring = artiststring
            }
            let urlstring = "https://api.genius.com/search?access_token=EAsZGVqEnWqQZmngYhqj1L2F8cVIaCcmWKJ0MNFQiF31P5fAfsy3oE2klgLFVMtp&q=\(String(describing: finaltitlestring))%20\(String(describing: finalartiststring))"
            guard let url = URL(string: urlstring) else{return }
            let request = NSMutableURLRequest.init(url: url)
            request.httpMethod = "GET"

            URLSession.shared.dataTask(with: url)
            { (data, response, error) in
                if let error = error
                {
                    print(error)

                }

                let key = titlestring + " " + artiststring
                guard let data = data else
                {
                    MainPlayerViewController.shared.lyricstextview.text = "lyrics not available"
                    return
                    
                }
                let keystring = key.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
                self.scrubLink(data: data, titlestring: titlestring, artiststring: artiststring, key : keystring)

              
                
                
            }.resume()
        }


    }
    
    func addlyrics(item : MPMediaItem)
    {
        
        guard var titlestring = item.title else{return }
        guard let artiststring = item.artist else{return }
        titlestring = parseTitleString(string: titlestring)
        var finaltitlestring = ""
        var finalartiststring = ""
        if titlestring.contains(" ")
        {
            finaltitlestring = titlestring.replacingOccurrences(of: " ", with: "%20")
        }
        else
        {
            finaltitlestring = titlestring
        }
        
        if artiststring.contains(" ")
        {
            finalartiststring = titlestring.replacingOccurrences(of: " ", with: "%20")
        }
        else
        {
            finalartiststring = artiststring
        }
        let urlstring = "https://api.genius.com/search?access_token=EAsZGVqEnWqQZmngYhqj1L2F8cVIaCcmWKJ0MNFQiF31P5fAfsy3oE2klgLFVMtp&q=\(String(describing: finaltitlestring))%20\(String(describing: finalartiststring))"
        guard let url = URL(string: urlstring) else{return }
        let request = NSMutableURLRequest.init(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            if let error = error
            {
                print(error)

            }

            let key = titlestring + " " + artiststring
            guard let data = data else
            {
                print("returned nothing")
                MainPlayerViewController.shared.lyricstextview.text = "lyrics not available"
                return
                
            }

            let keystring = key.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
            
            self.scrubLink(data: data, titlestring: titlestring, artiststring: artiststring, key : keystring)
            
           

          
            
            
        }.resume()
    }
    func scrubLink(data : Data, titlestring: String, artiststring: String, key : String)
    {
        do
        {
            if let json = try JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any>,
          let applicationStateJson = json["response"] as? Dictionary<String, Any> {
              let hits = applicationStateJson["hits"] as? Array<Any>
              //let result = hits["results"]
              //print(applicationStateJson)
              for hit in hits!
              {
                
                  guard let  onehit = hit as? Dictionary<String, Any> else{return}
                  guard let  result = onehit["result"] as? Dictionary<String, Any> else{return}
                  guard let  a_name = result["primary_artist"] as? Dictionary<String, Any> else{return}
                  if a_name["name"] as? String == artiststring && result["title"] as? String == titlestring
                  {

                      guard let  url = result["url"] as? String  else{return}
                        if let url = URL(string: url) {
                            do {
                                let contents = try String(contentsOf: url)
                                do {
                                   let doc: Document = try SwiftSoup.parse(contents)
                                    let lyric_class: Elements  = try doc.getElementsByClass("lyrics")
                                    let p: Element? = try lyric_class.select("p").first()
                                    let final_lyric = try p?.html()
                                    print("tester2",final_lyric)
                                    if final_lyric == ""
                                    {
                                        MainPlayerViewController.shared.lyricstextview.text = "lyrics not available"
                                    }
                                    else
                                    {
                                        uploadTOFirebase(lyrics: final_lyric, key: key)
                                    }
                                   
                                    
                                } catch Exception.Error(let type, let message) {
                                    print(message)
                                    print(type)
                                } catch {
                                    print("error")
                                }
                                //print(contents)
                            } catch {
                                // contents could not be loaded
                                print(error)
                            }
                        } else {
                            // the URL was bad!
                        }
                    
                    
                    
                    
                      
                  }
                  
                  
              }
              
          }
        }
        catch  {print(error)}
    }
    
    func uploadTOFirebase(lyrics : String?, key : String)
    {
        count += 1
        let temp = parseHTML(string: lyrics!)
        wavedb.collection("Lyrics").document(key).setData([key : temp])
        print(temp)
        DispatchQueue.main.async
        {
            if  lyrics == ""
            {
                MainPlayerViewController.shared.lyricstextview.text = "lyrics not available"
                MainPlayerViewController.shared.lyricbuttondidtap()
            }
            else
            {
                MainPlayerViewController.shared.lyricstextview.text = temp
            }
        }
        

    }
    func testAPI(item : MPMediaItem)
    {
        guard var titlestring = item.title else{return }
        guard let artiststring = item.artist else{return }
        titlestring = parseTitleString(string: titlestring)
        var finaltitlestring = ""
        var finalartiststring = ""
        if titlestring.contains(" ")
        {
            finaltitlestring = titlestring.replacingOccurrences(of: " ", with: "%20")
        }
        else
        {
            finaltitlestring = titlestring
        }
        
        if artiststring.contains(" ")
        {
            finalartiststring = titlestring.replacingOccurrences(of: " ", with: "%20")
        }
        else
        {
            finalartiststring = artiststring
        }
        
        let urlstring = "https://api.genius.com/search?access_token=EAsZGVqEnWqQZmngYhqj1L2F8cVIaCcmWKJ0MNFQiF31P5fAfsy3oE2klgLFVMtp&q=\(String(describing: finaltitlestring))%20\(String(describing: finalartiststring))"
        guard let url = URL(string: urlstring) else{return }
        let request = NSMutableURLRequest.init(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            if let error = error
            {
                print(error)

            }

            let key = titlestring + " " + artiststring
            print(key)
            guard let data = data else
            {
                print("returned nothing")
                return
                
            }
            
                   do{
                       if let json = try JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any>,
                       let applicationStateJson = json["response"] as? Dictionary<String, Any> {
                           let hits = applicationStateJson["hits"] as? Array<Any>
                           //let result = hits["results"]
                           //print(applicationStateJson)
                           print(hits!)
                        
                           for hit in hits!
                           {
                               guard let  onehit = hit as? Dictionary<String, Any> else{return}
                               guard let  result = onehit["result"] as? Dictionary<String, Any> else{return}
                               guard let  a_name = result["primary_artist"] as? Dictionary<String, Any> else{return}
                               //guard let  wi_name = result["full_title"] as? String  else{return}
                               if a_name["name"] as? String == artiststring && result["title"] as? String == titlestring
                               {
                                   
                                   //print(a_name["name"] as Any)
                                   //print(result["title"] as? String)
                                   //print(result["url"] as? String, wi_name, titlestring)
                                   guard let  url = result["url"] as? String  else{return}
                                   //self.scrape(url)
                                     if let url = URL(string: url) {
                                         do {
                                             let contents = try String(contentsOf: url)
                                             do {
                                                let doc: Document = try SwiftSoup.parse(contents)
                                                 let lyric_class: Elements  = try doc.getElementsByClass("lyrics")
                                                 let p: Element = try lyric_class.select("p").first()!
                                                 let final_lyric = try p.html()
                                                 print(final_lyric)
                                                
                                                 
                                             } catch Exception.Error(let type, let message) {
                                                 print(message)
                                                 print(type)
                                             } catch {
                                                 print("error")
                                             }
                                             //print(contents)
                                         } catch {
                                             // contents could not be loaded
                                             print(error)
                                         }
                                     } else {
                                         // the URL was bad!
                                     }
                                 
                                 
                                 
                                 
                                   
                               }
                               
                               
                           }
                           //print(hits![0]["result"])
                           
                       }
                   }
                   catch  {print(error)}
            
           

          
            
            
        }.resume()
    }
    func parseTitleString(string : String) -> String
    {
        if string.contains("(feat.")
        {
            let range = (string as NSString).range(of: "(feat.", options: .caseInsensitive)
            let t = Array(string)
            let mySubstring = t[0..<range.location - 1]
            return String(mySubstring)
            //}
        }
        return string
    }
    func parseHTML(string : String) -> String
    {
        
        let attributed = try! NSAttributedString(data: string.data(using: .unicode)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        return attributed.string
    }
    
}
 
