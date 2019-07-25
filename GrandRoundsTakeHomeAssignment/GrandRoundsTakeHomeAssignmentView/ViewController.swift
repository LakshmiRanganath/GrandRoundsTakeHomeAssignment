//
//  ViewController.swift
//  GrandRoundsTakeHomeAssignment
//
//  Created by Lakshmi Madhu on 7/16/19.
//  Copyright © 2019 Lakshmi Madhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var searchString = ""
    var grandRoundsTHAViewModel = GrandRoundsTHAViewModel()
    var pageCount = 1
    var indexPathOfLastDisplayedCell = IndexPath()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageSearchBar: UISearchBar!
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var imageSearchCollectionView: UICollectionView!
    @IBOutlet weak var welcomeToSearchLabel: UILabel!
    
    // MARK: - PaginationMethodWithLoadMore
    @IBAction func loadMoreButtonTapped(_ sender: Any) {
        pageCount = pageCount + 1
        callSearch(searchString: searchString, pageCount: pageCount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Grand Rounds"
        activityIndicator.isHidden = true
        loadMoreButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    //MARK: - FetchSearchResults
    func callSearch(searchString : String, pageCount : Int){
        grandRoundsTHAViewModel.fetchImagesForSearchString(searchString: searchString, pageCount: pageCount , completion:{ resultFetched in
            switch(resultFetched){
            case .failure(let error) :
                //Display an alert to show error
                let alert = UIAlertController.init(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                //Try again action is added to alert and callFetch is called again.
                let action = UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
                    self.callSearch(searchString: searchString, pageCount: pageCount)
                })
                alert.addAction(action)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                DispatchQueue.main.async {[weak self] in
                    self?.present(alert, animated: true)
                }
                
            case .success(let arrayFetched) :
                //if data is fetched succefully, collectionView  is reloaded
                self.grandRoundsTHAViewModel.imageSearchResultsArray.append(contentsOf: arrayFetched)
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.isHidden = false
                    self?.welcomeToSearchLabel.isHidden = true
                    self?.imageSearchCollectionView.reloadData()
                    if pageCount > 1{
                        self?.imageSearchCollectionView.scrollToItem(at: self?.indexPathOfLastDisplayedCell ?? IndexPath(), at: .centeredHorizontally, animated: true)
                    }
                    self?.imageSearchCollectionView.isHidden = false
                    self?.loadMoreButton.isHidden = false
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                }
            }
        })
    }
}
//MARK: - CollectionViewDataSourceMethods
extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grandRoundsTHAViewModel.imageSearchResultsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GrandRoundsTHACollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "grandRoundsTHACollectionViewCell", for: indexPath) as! GrandRoundsTHACollectionViewCell
        let imageDetail = grandRoundsTHAViewModel.imageSearchResultsArray[indexPath.row]
        let imageURLString = "https://farm\(String(imageDetail.farm)).staticflickr.com/\(imageDetail.server)/\(imageDetail.id)_\(imageDetail.secret).jpg"
        cell.searchImageUrlString = imageURLString
        cell.searchImageView.loadImageViewWithUrlString(urlString: imageURLString)
        if indexPath.row == grandRoundsTHAViewModel.imageSearchResultsArray.count - 1{
            //used to scroll to last loaded cell when collectionview is reloaded, after pagination
            self.indexPathOfLastDisplayedCell = indexPath
        }
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoDisplayVC = storyboard.instantiateViewController(withIdentifier: "SearchImageDisplayViewController") as! PhotoViewController
        
        let imageDetail = grandRoundsTHAViewModel.imageSearchResultsArray[indexPath.row]
        let imageURLString = "https://farm\(String(imageDetail.farm)).staticflickr.com/\(imageDetail.server)/\(imageDetail.id)_\(imageDetail.secret).jpg"
        DispatchQueue.main.async {
            //IBOutlets were getting nil as view was not loaded
            let _ = photoDisplayVC.view
            photoDisplayVC.photoImageView.loadImageViewWithUrlString(urlString: imageURLString)
            photoDisplayVC.photoImageTitleLabel.text = imageDetail.title
            self.navigationController?.pushViewController(photoDisplayVC, animated: true)
        }
        
    }
    
}
extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.imageSearchCollectionView.frame.size.width * 0.5) - 40, height: (self.imageSearchCollectionView.frame.size.height * 0.4) - 40)
    }
    
}
extension ViewController : UICollectionViewDelegate{
    
    
}
extension ViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        imageSearchBar.resignFirstResponder()
        searchString = searchBar.text ?? ""
        callSearch(searchString: searchString, pageCount: pageCount)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        imageSearchBar.resignFirstResponder()
        loadMoreButton.isHidden = true
        imageSearchCollectionView.isHidden = true
        welcomeToSearchLabel.isHidden = false
        activityIndicator.isHidden = true
        searchString = ""
        pageCount = 0
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        imageSearchBar.resignFirstResponder()
        searchString = searchBar.text ?? ""
    }
    
    
}

