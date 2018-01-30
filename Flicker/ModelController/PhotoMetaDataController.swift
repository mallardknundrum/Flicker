//
//  PhotoController.swift
//  Flicker
//
//  Created by Jeremiah Hawks on 1/28/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import Foundation
import UIKit

class PhotoMetaDataController {
    
    static let singleton = PhotoMetaDataController()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    func constructPhotoURL() {
        
    }
    
    func getPhoto(withURL url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        let optionalData: NSData? = (try? NSData(contentsOf: url))
        if let data = optionalData {
            guard let image = UIImage(data: data as Data) else { return }
            imageCache.setObject(image, forKey: url.absoluteString as NSString)
            completion(image)
            return
        } else {
            completion(nil)
            return
        }
    }
}
