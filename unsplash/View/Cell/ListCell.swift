//
//  ListCell.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func configure(_ image: Image) {
        guard let urls = image.urls, let regular = urls.regular else { return }
        self.imageView.loadImage(regular)
        
        guard let name = image.user?.name else { return }
        self.nameLabel.text = name
    }
}
