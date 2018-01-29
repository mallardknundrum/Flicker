//
//  ViewController.swift
//  Flicker
//
//  Created by Jeremiah Hawks on 1/28/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let networkController = NetworkController()
    
    @IBAction func buttonPressed(_ sender: Any) {
//        let extras = "description,date_upload,date_taken,owner_name,last_update,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_l,url_o"
//        let parameters = ["username": "Jeremiah", "extras": extras]
//        networkController.performRequest(for: .getPopular, httpMethod: .Get, urlParameters: parameters, body: nil) { (data, error) in
//            var photoMetaArray: [PhotoMetaData] = []
//            if let data = data {
//                if let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]){
//                    guard let photos = json?["photos"] as? [String: Any], let photosDictionary = photos["photo"] as? [[String: Any]] else { return }
//                    for photo in photosDictionary {
//                        guard let photoMeta = PhotoMetaData(jsonDictionary: photo) else { return }
//                        photoMetaArray.append(photoMeta)
//                    }
//                    
//                }
//            }
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

