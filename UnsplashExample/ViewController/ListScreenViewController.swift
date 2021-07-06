//
//  ViewController.swift
//  UnsplashExample
//
//  Created by Derrick Wilde on 7/5/21.
//

import UIKit

class ListViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate {
    
    let viewModel = ListScreenViewModel()
    var results: [SearchResult] = []
    var isLoading = false
    var previousQuery = ""
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    @IBOutlet weak var photoListSerachBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Spending more time on this would have me implementing core data (or having us keep information on an external object) that would could prepopulate this with the last result the user searched.
        prepareCollectionView()
        photoListSerachBar.delegate = self
        activityIndicator.isHidden = true
    }
    override func awakeFromNib() {
//        activityIndicator.isHidden = false
    }
    func prepareCollectionView() {
        photoListCollectionView.dataSource = self
        photoListCollectionView.delegate = self
        photoListCollectionView.register(PhotoListCollectionViewCell.self, forCellWithReuseIdentifier: PhotoListCollectionViewCell.identifier)
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            activityIndicator.isHidden = false
            viewModel.searchPictures(query: previousQuery, page: (viewModel.currentPage + 1)) { [weak self] (data, error) in
                if let searchResults = data?.results {
                    guard let strongSelf = self else { return }
                    strongSelf.results += searchResults
                    strongSelf.viewModel.currentPage = Int((strongSelf.results.count/30).magnitude)
                    DispatchQueue.main.async {
                        strongSelf.photoListCollectionView.reloadData()
                        strongSelf.isLoading = false
                        strongSelf.activityIndicator.isHidden = true
                    }
                }
            }
        }
    }

    /// MARK: Delegate Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoUrl = results[indexPath.row].urls.regular
        // Guarding in case this cast ever fails (it shouldnt, but it doesn't hurt to be safe)
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoListCollectionViewCell.identifier, for: indexPath) as? PhotoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        photoCell.setCellImage(url: photoUrl)
        return photoCell
    }
    
    // Checks to see if we are almost at the end of our availble photos and if we are, calls for more.
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == results.count - 5 && !self.isLoading {
            self.loadMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urls = results[indexPath.row].urls
        let user = results[indexPath.row].user
        let description = results[indexPath.row].description
        
        guard let photoDetailsVC = UIStoryboard(name: StoryBoardIds.photoDetails.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: "PhotoDetailsViewController") as? PhotoDetailsViewController else {
            return
        }
        photoDetailsVC.descLabel = description ?? ""
        photoDetailsVC.thumbUrl = urls.thumb
        photoDetailsVC.largeUrl = urls.full
        photoDetailsVC.nameLabel = user.name
        photoDetailsVC.userLabel = user.username
        self.navigationController?.pushViewController(photoDetailsVC, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            results = []
            photoListCollectionView.reloadData()
            activityIndicator.isHidden = false
            viewModel.searchPictures(query: searchText) { [weak self] (data, error) in
                guard let strongSelf = self else { return }
                strongSelf.previousQuery = searchText
                // This logic would be moved to the view model with observables and data binding, but for the sake of time management it isn't the end of the world to do a small amount of business logic here.
                DispatchQueue.main.async {
                    strongSelf.activityIndicator.isHidden = true
                }
                if let results = data?.results {
                    strongSelf.results = results
                    // This will tell us what the current page is so we know what page to grab next without having to manually keep count.
                    strongSelf.viewModel.currentPage = Int((results.count/30).magnitude)
                    DispatchQueue.main.async {
                        strongSelf.photoListCollectionView.reloadData()
                    }
                }
                if let error = error {
                    print(error)
                }
            }
        }
    }
}

