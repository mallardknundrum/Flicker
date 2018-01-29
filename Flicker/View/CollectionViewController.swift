//
//  CollectionViewController.swift
//  Flicker
//
//  Created by Jeremiah Hawks on 1/28/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UISearchResultsUpdating {
    
    
    
    var searchController: UISearchController?
    var photoMetaDataArray: [PhotoMetaData] = []
    var backButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchController()
        setUpCollectionView()
        let extras = "description,date_upload,date_taken,owner_name,last_update,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_l,url_o"
        let parameters = ["username": "Jeremiah", "extras": extras]
        NetworkController().performRequest(for: .getPopular, httpMethod: .Get, urlParameters: parameters, body: nil) { (data, error) in
            var photoMetaArray: [PhotoMetaData] = []
            if let data = data {
                if let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]){
                    guard let photos = json?["photos"] as? [String: Any], let photosDictionary = photos["photo"] as? [[String: Any]] else { return }
                    for photo in photosDictionary {
                        guard let photoMeta = PhotoMetaData(jsonDictionary: photo) else { return }
                        photoMetaArray.append(photoMeta)
                    }
                    self.photoMetaDataArray = photoMetaArray
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        
        let searchBar = searchController?.searchBar
        searchBar?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let sb = searchBar {
            self.collectionView?.addSubview(sb)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadInputViews()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FlickrDetailTableViewController,
            let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            vc.photoMetaData = self.photoMetaDataArray[indexPath.row]
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoMetaDataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flickrCollectionViewCell", for: indexPath) as? FlickrCollectionViewCell else { return UICollectionViewCell() }
        cell.photoMetaData = self.photoMetaDataArray[indexPath.row]
        cell.setUpViews()
        return cell
    }
    
    

    
    private func setUpSearchController() {
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsCollectionViewController")
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
//        searchController?.searchResultsController?.navigationItem.backBarButtonItem?.isEnabled = true
//        searchController?.searchResultsController?.navigationItem.hidesBackButton = false
        
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.navigationItem.hidesBackButton = false
        if let resultsViewController = searchController.searchResultsController as? SearchResultsCollectionViewController, let searchTerm = searchController.searchBar.text {
            // call api to search for user
            let parameters = ["username": searchTerm]
            NetworkController().performRequest(for: .searchForUser, httpMethod: .Get, urlParameters: parameters, body: nil, completion: { (data, error) in
                if let error = error {
                    
                }
                if let data = data {
                    guard let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
                        let userDictionary = json["user"] as? [String: Any],
                        let nsid = userDictionary["nsid"] as? String else { return }
                    let extras = "description,date_upload,date_taken,owner_name,last_update,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_l,url_o"
                    let parameters = ["user_id": nsid, "extras": extras]
                    NetworkController().performRequest(for: .getPhotosForUser, httpMethod: .Get, urlParameters: parameters, body: nil, completion: { (data, error) in
                        if let error = error {
                            
                        }
                        if let data = data {
                            if let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]){
                                guard let photos = json?["photos"] as? [String: Any], let photosDictionary = photos["photo"] as? [[String: Any]], let resultsViewController = searchController.searchResultsController as? SearchResultsCollectionViewController else { return }
                                var photoMetaArray: [PhotoMetaData] = []
                                for photo in photosDictionary {
                                    guard let photoMeta = PhotoMetaData(jsonDictionary: photo) else { return }
                                    photoMetaArray.append(photoMeta)
                                    resultsViewController.resultsArray = photoMetaArray
                                    DispatchQueue.main.async {
                                        resultsViewController.collectionView?.reloadData()
                                    }
                                    print(photoMeta.title)
                                }
                            }
                        }
                    })
                }
            })
        }
    }
    
    func setUpCollectionView() {
        let columnLayout = ColumnFlowLayout(
            cellsPerRow: UIDevice.current.userInterfaceIdiom == .phone ? 3 : 5,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        )
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
    }
}
