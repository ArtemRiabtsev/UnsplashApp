//
//  MainScreenViewController.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
class MainScreenViewController: UICollectionViewController {
    
    var presenter: MainScreenPresenterProtocol?
    let searchBar = UISearchBar()
    var dataArray = Array<Any>()
    var layout: CustomLayout!
    var flag = false {
        didSet{
            currentPage = 1
        }
    }
    var currentPage = 1
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layout = collectionViewLayout as! CustomLayout
        self.layout.delegate = self
        
        
        self.presenter?.setUpView(page: currentPage)
 
        self.searchBar.showsCancelButton = true
        self.searchBar.placeholder = "enter keyword..."
        self.searchBar.delegate = self
        self.searchBar.spellCheckingType = .yes
        self.searchBar.autocorrectionType = .yes
        
        self.navigationItem.titleView = self.searchBar
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        layout.invalidateLayout()
    }
}

extension MainScreenViewController: UnsplashLayoutDelegate {
    func collectionView(_collectionView collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> (CGFloat) {
        if !self.dataArray.isEmpty {
            let item = self.dataArray[indexPath.row] as! ImageInfo
            
            return (item.image?.size.height)!
            
        }
        return 200
    }
        
}
//MARK: UISearchBar delegate
extension MainScreenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            self.flag = true
            self.currentPage += 1
            self.dataArray.removeAll()
            self.presenter?.setUpViewWithSearchResult(page: self.currentPage, keyword: keyword)
            searchBar.resignFirstResponder()
        }
    }
}

//MARK: Main screen view protocol
extension MainScreenViewController: MainScreenViewProtocol {
    
    func showSearchResultImageList(imageList: [ImageInfo]) {
        
        self.dataArray.append(contentsOf: imageList)
        
        DispatchQueue.main.async {
            self.layout.invalidateLayout()
            self.collectionView?.reloadData()
        }
    }
    
    
    func showImageList(imageList: [ImageInfo]) {
        
        self.dataArray.append(contentsOf: imageList)
        
        DispatchQueue.main.async {
            self.layout.invalidateLayout()
            self.collectionView?.reloadData()
        }
    }
}
//MARK: UICollection View Delegate
extension MainScreenViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.dataArray.count - 1 {
            if !self.flag {
                self.currentPage += 1
                self.presenter?.setUpView(page: self.currentPage)
            }else {
                print(indexPath.row)
                self.currentPage += 1
                self.presenter?.setUpViewWithSearchResult(page: self.currentPage, keyword: searchBar.text!)
            }
        }
    }

}
//MARK: UICollection View Data Source
extension MainScreenViewController {
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        if !self.dataArray.isEmpty {
            
            let item = self.dataArray[indexPath.row] as! ImageInfo
            cell.countOfLikes.text = "❤️ \(item.likes ?? 0) "
            cell.imageView.image = item.image
            cell.userName.text = item.userName
        }
 
        return cell
    }
}
