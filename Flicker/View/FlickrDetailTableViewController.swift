//
//  FlickrDetailTableViewController.swift
//  Flicker
//
//  Created by Jeremiah Hawks on 1/28/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import UIKit

class FlickrDetailTableViewController: UITableViewController {

    var photoMetaData: PhotoMetaData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = UIScreen.main.bounds.width
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
