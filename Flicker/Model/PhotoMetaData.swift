//
//  PhotoMetaData.swift
//  Flicker
//
//  Created by Jeremiah Hawks on 1/28/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import Foundation

class PhotoMetaData {
    let owner: String
    let title: String
    let description: String
    let dateUploaded: String
    let dateTaken: String
    let ownerName: String
    let lastUpdate: String
    let tags: String
    let machineTags: String
    let viewCount: String
    let squareThumbnailURLString: String
    let largeImageURLString: String
    let originalImageURLString: String
    let infoArray: [(title: String, value: String)]
    
    init?(jsonDictionary: [String: Any]) {
        guard let owner = jsonDictionary["owner"] as? String,
            let title = jsonDictionary["title"] as? String,
            let descriptionDictionary = jsonDictionary["description"] as? [String: Any],
            let descriptionContent = descriptionDictionary["_content"] as? String,
            let dateUploaded = jsonDictionary["dateupload"] as? String,
            let dateTaken = jsonDictionary["datetaken"] as? String,
            let ownerName = jsonDictionary["ownername"] as? String,
            let lastUpdate = jsonDictionary["lastupdate"] as? String,
            let tags = jsonDictionary["tags"] as? String,
            let machineTags = jsonDictionary["machine_tags"] as? String,
            let viewCount = jsonDictionary["views"] as? String,
            let squareThumbnailString = jsonDictionary["url_sq"] as? String,
            let largeImageURLString = jsonDictionary["url_l"] as? String else { return nil }
        self.owner = owner
        self.title = title
        self.description = descriptionContent
        self.dateUploaded = dateUploaded
        self.dateTaken = dateTaken
        self.ownerName = ownerName
        self.lastUpdate = lastUpdate
        self.tags = tags
        self.machineTags = machineTags
        self.viewCount = viewCount
        self.squareThumbnailURLString = squareThumbnailString
        self.largeImageURLString = largeImageURLString
        if let originalImageURLString = jsonDictionary["url_o"] as? String {
            self.originalImageURLString = originalImageURLString
        } else {
            self.originalImageURLString = ""
        }
        self.infoArray = [("Photo Credit:", ownerName),
                          ("Title: ", title), ("Description:", descriptionContent),
                          ("Date Taken: ", dateTaken),
                          ("Tags: ", tags),
                          ("Machine Tags: ", machineTags),
                          ("Views: ", viewCount)]
    }
}
