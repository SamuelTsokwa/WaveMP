//
//  MainPlayerCollectionViewCell.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-28.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit

class MainPlayerCollectionViewCell: UICollectionViewCell {

    let extraview = UIView()
    var gradientview: CAGradientLayer = CAGradientLayer()
    @IBOutlet var artwork: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        artwork.contentMode = .scaleToFill
        artwork.translatesAutoresizingMaskIntoConstraints = false
        artwork.image = UIImage(named: "defaultmusicimage")
        
        gradientview.frame = artwork.frame
        extraview.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(extraview)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didtap))
//        extraview.addGestureRecognizer(tap)
//


//        NSLayoutConstraint.activate([
//            extraview.leftAnchor.constraint(equalTo: self.leftAnchor),
//            extraview.rightAnchor.constraint(equalTo: self.rightAnchor),
//            extraview.topAnchor.constraint(equalTo: self.topAnchor),
//            extraview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//
//        ])

        
        //gradient.frame = self.bounds
        extraview.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        artwork.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        gradientview.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor ]
        gradientview.locations = [0.0, 0.8, 1.0]
        artwork.layer.insertSublayer(gradientview, at: 0)
        

    }
    
    override func layoutSubviews() {
        gradientview.frame = self.bounds
    }
    @objc func didtap()
    {
        UIView.animate(withDuration: 0.2) {
            self.extraview.backgroundColor = .clear
        }
    }
    
    
    

}
