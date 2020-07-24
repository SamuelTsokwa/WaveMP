//
//  CollectionTableViewCell.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-18.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {
    @IBOutlet var sectionlabel: UILabel!
    
    @IBOutlet var cellcollectionview: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
