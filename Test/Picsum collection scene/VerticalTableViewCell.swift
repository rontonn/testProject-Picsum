//
//  VerticalTableViewCell.swift
//  Test
//
//  Created by Anton Romanov on 24/10/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import UIKit

class VerticalTableViewCell: UITableViewCell {

    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        horizontalCollectionView.layer.cornerRadius = 12.0
        // Initialization code
    }

}
