//
//  CollectionViewController.swift
//  Flicker
//
//  Created by Jeremiah Hawks on 1/28/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: Properties
    
    var searchController: UISearchController?
    var photoMetaDataArray: [PhotoMetaData] = []
    var resultsArray: [PhotoMetaData] = []
    
    // MARK: outlets
    
    @IBAction func interestingButtonTapped(_ sender: Any) {
        resultsArray = []
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
        setUpCollectionView()
        let extras = "description,date_upload,date_taken,owner_name,last_update,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_l,url_o"
        let parameters = ["username": "Jeremiah", "extras": extras]
        // call api to return metadata for the top interesting photos
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
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FlickrDetailTableViewController,
            let cell = sender as? UICollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            vc.photoMetaData = !resultsArray.isEmpty ?  self.resultsArray[indexPath.row] : self.photoMetaDataArray[indexPath.row]
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // if resultsArray is empty, it is displaying the search results, if not, its displaying the main interesting feed
        return !resultsArray.isEmpty ? resultsArray.count : photoMetaDataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flickrCollectionViewCell", for: indexPath) as? FlickrCollectionViewCell else { return UICollectionViewCell() }
        
        // if resultsArray is empty, it is displaying the search results, if not, its displaying the main interesting feed
        if !resultsArray.isEmpty {
            let meta = resultsArray[indexPath.row]
            cell.photoMetaData = meta
            DispatchQueue.global().async {
                PhotoMetaDataController.singleton.getThumbnail(photoMetaData: meta, completion: { (image) in
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                })
            }
        } else {
            let meta = photoMetaDataArray[indexPath.row]
            cell.photoMetaData = meta
            DispatchQueue.global().async {
                PhotoMetaDataController.singleton.getThumbnail(photoMetaData: meta, completion: { (image) in
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                })
                
            }
        }
        return cell
    }
    
    
    
    
    //MARK: UISearchResultsUpdating methods
    
    func updateSearchResults(for searchController: UISearchController) {
        DispatchQueue.main.async {
            guard self.isSearching() else { return }
        }
        self.navigationItem.hidesBackButton = false
        if let searchTerm = searchController.searchBar.text {
            // call api to search for user in the search bar
            let parameters = ["username": searchTerm]
            NetworkController().performRequest(for: .searchForUser, httpMethod: .Get, urlParameters: parameters, body: nil, completion: { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let data = data {
                    guard let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
                        let userDictionary = json["user"] as? [String: Any],
                        let nsid = userDictionary["nsid"] as? String else { return }
                    let extras = "description,date_upload,date_taken,owner_name,last_update,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_l,url_o"
                    let parameters = ["user_id": nsid, "extras": extras]
                    // call api to get metadata for public photos that the user has
                    NetworkController().performRequest(for: .getPhotosForUser, httpMethod: .Get, urlParameters: parameters, body: nil, completion: { (data, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        if let data = data {
                            DispatchQueue.main.async {
                                guard self.isSearching() else { return }
                            }
                            if let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]){
                                guard let photos = json?["photos"] as? [String: Any], let photosDictionary = photos["photo"] as? [[String: Any]] else { return }
                                var photoMetaArray: [PhotoMetaData] = []
                                for photo in photosDictionary {
                                    if let photoMeta = PhotoMetaData(jsonDictionary: photo) {
                                        photoMetaArray.append(photoMeta)
                                    }
                                }
                                self.resultsArray = photoMetaArray
                                DispatchQueue.main.async {
                                    self.collectionView?.reloadData()
                                }
                            }
                        }
                    })
                }
            })
        }
    }
    
    // MARK: Search Bar Delegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        DispatchQueue.main.async {
            self.resultsArray = []
            self.collectionView?.reloadData()
        }
    }
    
    //MARK: Setup and helper functions
    
    private func setUpSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
    
    func isSearching() -> Bool {
        guard let searchController = searchController,  let text = searchController.searchBar.text else { return false }
        return searchController.isActive && !text.isEmpty
    }
}
