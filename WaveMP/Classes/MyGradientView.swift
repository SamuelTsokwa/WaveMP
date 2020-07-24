//
//  MyGradientView.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-07-20.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import Foundation
import UIKit

class MyGradientView : UIView {
    override class var layerClass : AnyClass { return CAGradientLayer.self }
    lazy var gradientLayer = self.layer as! CAGradientLayer
    private func config() {
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor ]
        gradientLayer.locations = [0.0, 1.0]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
    }
    
   
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .clear
        self.config()
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.config()
    }
    
}
