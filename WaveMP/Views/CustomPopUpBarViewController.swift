//
//  CustomPopUpBarViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-07-18.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
import LNPopupController

class CustomPopUpBarViewController: LNPopupCustomBarViewController {
    @IBOutlet var miniPlayer: MiniPlayer!
    var vcon: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        preferredContentSize = CGSize(width: -1, height: 65)
//        miniPlayer.viewcontroller = vcon!
    }
    
    override var wantsDefaultPanGestureRecognizer: Bool
    {
        get
        {
            return true;
        }
    }
    
    
    override func popupItemDidUpdate() {
        print(popupPresentationState.rawValue)
        popoverPresentationController?.barButtonItem = nil
        
    }
    
    
}
