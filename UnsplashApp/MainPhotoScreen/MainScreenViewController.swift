//
//  MainScreenViewController.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit
import Kingfisher
class MainScreenViewController: UICollectionViewController {
    
    var presenter: MainScreenPresenterProtocol?
    let searchBar = UISearchBar()
    
//                                          ///
    var dataArray = Array<Any>()            ////
    let leftRightPaddings: CGFloat = 32     //////   ????????????
    let numberOfItemsPerRow: CGFloat = 2    ////
    let heightAdjustment: CGFloat = 30      ///
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter?.setUpView()
        
        self.searchBar.showsCancelButton = true
        self.searchBar.placeholder = "enter keyword..."        
        self.navigationItem.titleView = self.searchBar
        
        
        let width = (collectionView!.frame.width - self.leftRightPaddings) / self.numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width + self.heightAdjustment)

    }
}
//MARK: Main screen view protocol
extension MainScreenViewController: MainScreenViewProtocol {
    
    func showImageList(imageList: [ImageInfo]) {
        
        self.dataArray = imageList

        self.collectionView?.reloadData()
    }
}
//MARK: UICollection View Data Source
extension MainScreenViewController {
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        if !self.dataArray.isEmpty {
            
            let item = self.dataArray[indexPath.row] as! ImageInfo
            
            
            let url = URL(string: item.urls!["small"] as! String)
            
            cell.countOfLikes.text = "❤️ \(item.likes ?? 0)"
            
            cell.imageView.kf.setImage(with: url)
        }
        
        return cell
    }
}
