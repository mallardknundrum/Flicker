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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUpViews() {
        DispatchQueue.global().async {
            guard let urlString = self.imageURLString, let url = URL(string: urlString) else { return }
            PhotoController.singleton.getPhoto(withURL: url) { (image) in
                DispatchQueue.main.async {
                    self.flickrImageView.image = image
                }
            }
        }
    }
}
