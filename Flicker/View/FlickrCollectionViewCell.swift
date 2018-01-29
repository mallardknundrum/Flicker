//
//  FlickrCollectionViewCell.swift
//  Flicker
//
//  Created by Jeremiah Hawks on 1/28/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import UIKit

class FlickrCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var photoMetaData: PhotoMetaData?
    
    func setUpViews() {
        DispatchQueue.global().async {
            guard let photoMetaData = self.photoMetaData, let thumbnailURL = URL(string: photoMetaData.squareThumbnailURLString) else { return }
            PhotoController.singleton.getPhoto(withURL: thumbnailURL, completion: { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            })
        }
    }
}
