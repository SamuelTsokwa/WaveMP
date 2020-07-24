//
//  Delegates.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-10.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import Foundation
import MediaPlayer

//protocol addupnextdel {
//    func addupnextdelegate(item : MPMediaItem) -> UIContextMenuConfiguration
//}

protocol updateCell {
    func updatecell(cell : SongListCell)
}

protocol pagecontrollerprotocol {
    func getVCIndex(vc : UIViewController)
    func goNextPage(position: Int)
}

protocol seguefromsearch {
    func activateseguetoplaylist(playlist : MPMediaItemCollection?)
    func activateseguetoAlbum(album : [MPMediaItem]?)
}

class PVC: NSObject {
    static let sharedInstance = PVC()
    private override init() {}
    @objc dynamic var currindex = -1
    @objc dynamic var contentHeight = 0
    @objc dynamic var childDidStartSCrolling = true
    
}

 
