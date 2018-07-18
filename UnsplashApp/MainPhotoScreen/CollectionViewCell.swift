//
//  CollectionViewCell.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countOfLikes: UILabel!
    @IBOutlet weak var userName: UILabel!
    override func draw(_ rect: CGRect) {
        countOfLikes.layer.masksToBounds = true
        countOfLikes.layer.cornerRadius = 5
        userName.layer.masksToBounds = true
        userName.layer.cornerRadius = 5
    }
}
