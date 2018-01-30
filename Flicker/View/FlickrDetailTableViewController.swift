//
//  FlickrDetailTableViewController.swift
//  Flicker
//
//  Created by Jeremiah Hawks on 1/28/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import UIKit

class FlickrDetailTableViewController: UITableViewController {

    // MARK: Properties
    
    var photoMetaData: PhotoMetaData?
    
    // MARK: lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = UIScreen.main.bounds.width
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        guard let meta = photoMetaData else { return 0 }
        return meta.infoArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? FlickrImageTableViewCell, let meta = self.photoMetaData else { return UITableViewCell() }
            if !meta.originalImageURLString.isEmpty {
                cell.imageURLString = meta.originalImageURLString
            } else {
                cell.imageURLString = meta.largeImageURLString
            }
            cell.setUpViews()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            return cell
        }
        if indexPath.section == 1 {
            guard let meta = self.photoMetaData else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "flickrInformationCell", for: indexPath)
            cell.textLabel?.text = meta.infoArray[indexPath.row].title
            cell.detailTextLabel?.text = meta.infoArray[indexPath.row].value
            return cell
        }
        return UITableViewCell()
    }
}
