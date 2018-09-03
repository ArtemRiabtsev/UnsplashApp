//
//  MainScreenViewController.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit
class MainScreenViewController: UICollectionViewController {
    
    var presenter: MainScreenPresenterProtocol?
    let searchBar = UISearchBar()
    var photoDataArray = Array<Photo>()
    var imageDataArray = Array<ImageInfo>()
    var layout = CustomLayout()
    var maxPageNumber = 999
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var currentPage = 1

    var flag = false {
        didSet{
            currentPage = 1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter?.setUpView(page: currentPage)
        
        self.layout = self.collectionViewLayout as! CustomLayout
        self.layout.delegate = self
        
        self.searchBar.showsCancelButton = true
        self.searchBar.placeholder = "enter keyword..."
        self.searchBar.delegate = self
        self.searchBar.spellCheckingType = .yes
        self.searchBar.autocorrectionType = .yes
        
        self.navigationItem.titleView = self.searchBar
        self.view.addSubview(activityView)
        self.activityView.color = UIColor.red
        self.activityView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.activityView.backgroundColor = UIColor.white
        self.activityView.alpha = 0.5
        self.activityView.hidesWhenStopped = true
        self.activityView.center = self.view.center
        
        let statusLabel = UILabel(frame: CGRect(x: self.activityView.center.x - 75,
                                                y: self.activityView.center.y + 50,
                                                width: 150,
                                                height: 28))
        statusLabel.text = "loading..."
        statusLabel.textAlignment = .center
        statusLabel.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        self.activityView.addSubview(statusLabel)
        self.activityView.startAnimating()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.activityView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.layout.invalidateLayout()
    }
}

//MARK: Unsplash Layout Delegate
// Returns the height of the photo to calculate the height of the cell
extension MainScreenViewController: UnsplashLayoutDelegate {
    func collectionView(_collectionView collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> (CGFloat) {
        if !self.photoDataArray.isEmpty {
            let img = self.photoDataArray[indexPath.item]            
            return img.image.size.height
        }
        return 0
    }
}
//MARK: UISearchBar delegate
extension MainScreenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.activityView.startAnimating()
        
        if searchBar.text != nil && searchBar.text != "" {
            self.flag = true
            
            self.presenter?.setUpViewWithSearchResult(page: self.currentPage, keyword: searchBar.text!)
        }
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if self.flag {
            self.activityView.startAnimating()
            self.flag = false
            self.maxPageNumber = 999
            self.cleareData()
            self.presenter?.setUpView(page: self.currentPage)
        }
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    func cleareData() -> Void {
        
        photoDataArray.removeAll()
        imageDataArray.removeAll()
        self.layout.cache.removeAll()
        self.layout.contentHeight = 0
    }
}
//MARK: Main screen view protocol
extension MainScreenViewController: MainScreenViewProtocol {

    func showImageList(imageList:ListViewModel) {
   
        switch true {
            
        case self.flag == true && imageList.searchResult?.total == 0:
            notFound()
        case self.flag && imageList.searchResult?.total != 0 && self.currentPage == 1:
            self.maxPageNumber = (imageList.searchResult?.total_pages)!
            cleareData()
        default:
            break
        }
        
        self.photoDataArray.append(contentsOf: imageList.photos)
        self.imageDataArray.append(contentsOf: imageList.images)
            
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.layout.invalidateLayout()
            self.activityView.stopAnimating()
        }
    }
    
    func notFound() {
        let alert = alertFuncWithOK(title: "Not found", message: "try another keyword")
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoadingErrorMessage(errorMessage: String) {
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
        }
        let title = errorMessage
        let alert = alertFuncWithOK(title: title, message: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
    //// - - accessory func
    
    func alertFuncWithOK(title: String, message: String?) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        return alert
    }
}
//MARK: UICollection View Delegate
extension MainScreenViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
        if indexPath.row == self.photoDataArray.count - 1 {
            
            self.currentPage += 1
            if self.currentPage <= self.maxPageNumber {
                
                self.activityView.startAnimating()
                
                if !self.flag {
                    self.presenter?.setUpView(page: self.currentPage)
                }else {
                    self.presenter?.setUpViewWithSearchResult(page: self.currentPage, keyword: searchBar.text!)
                }
            } else {
                return
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let image = self.photoDataArray[indexPath.item]
        let photoID = self.imageDataArray[indexPath.item]
        self.presenter?.pushDetail(id: photoID.id, image: image.image)
    }
}
//MARK: UICollection View Data Source
extension MainScreenViewController {
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.photoDataArray.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        if !self.photoDataArray.isEmpty {
            
            let imgInfo = self.imageDataArray[indexPath.row]

            let img = self.photoDataArray[indexPath.row]
            
            cell.countOfLikes.text = "❤️ \(imgInfo.likes ) "
            cell.imageView.image = img.image
            cell.userName.text = imgInfo.user.name
        }
        return cell
    }
}

