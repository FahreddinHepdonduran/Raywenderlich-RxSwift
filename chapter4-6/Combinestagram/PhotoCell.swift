//
//  PhotoCell.swift
//  Combinestagram
//
//  Created by fahreddin on 6.02.2021.
//  Copyright © 2021 fahreddin. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    var representedAssetIdentifier: String!

    override func prepareForReuse() {
      super.prepareForReuse()
      imageView.image = nil
    }

    func flash() {
      imageView.alpha = 0
      setNeedsDisplay()
      UIView.animate(withDuration: 0.5, animations: { [weak self] in
        self?.imageView.alpha = 1
      })
    }
    
}
