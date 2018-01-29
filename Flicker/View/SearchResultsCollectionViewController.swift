//
//  SearchResultsCollectionViewController.swift
//  Flicker
//
//  Created by Jeremiah Hawks on 1/29/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import UIKit

class SearchResultsCollectionViewController: UICollectionViewController {
    
    var resultsArray: [PhotoMetaData]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }

    let columnLayout = ColumnFlowLayout(
        cellsPerRow: UIDevice.current.userInterfaceIdiom == .phone ? 3 : 5,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(#imageLiteral(resourceName: "backButton"), for: .normal) // Image can be downloaded from here below link
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FlickrDetailTableViewController,
            let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell), let array = resultsArray {
            vc.photoMetaData = array[indexPath.row]
            vc.navigationItem.hidesBackButton = false
            print(vc.navigationController)
            vc.navigationController?.setNavigationBarHidden(false, animated: true)
            vc.navigationController?.setToolbarHidden(false, animated: true)
            vc.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
            vc.navigationController?.setToolbarItems([navigationItem.backBarButtonItem!], animated: true)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsArray?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flickrCollectionViewCell", for: indexPath) as? FlickrCollectionViewCell, let array = self.resultsArray else { return UICollectionViewCell() }
        cell.photoMetaData = array[indexPath.row]
        cell.setUpViews()
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }

}
