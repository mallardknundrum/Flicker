//
//  FlickrImageTableViewCell.swift
//  Flicker
//
//  Created by Jeremiah Hawks on 1/28/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import UIKit

class FlickrImageTableViewCell: UITableViewCell {

    var imageURLString: String?
    
    @IBOutlet weak var flickrImageView: UIImageView!

    func setUpViews() {
        DispatchQueue.global().async {
            guard let urlString = self.imageURLString, let url = URL(string: urlString) else { return }
            PhotoMetaDataController.singleton.getPhoto(withURL: url) { (image) in
                DispatchQueue.main.async {
                    self.flickrImageView.image = image
                }
            }
        }
    }
}
