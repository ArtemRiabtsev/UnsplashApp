//
//  MainScreenViewController.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit
import Kingfisher
class MainScreenViewController: UICollectionViewController, MainScreenViewProtocol {

    var presenter: MainScreenPresenterProtocol?
//
    var dataAr = Array<Any>()
    let leftRightPaddings: CGFloat = 32
    let numberOfItemsPerRow: CGFloat = 3
    let heightAdjustment: CGFloat = 30
//
    override func viewDidLoad() {
        super.viewDidLoad()
        //test request
        let width = (collectionView!.frame.width - self.leftRightPaddings) / self.numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width + self.heightAdjustment)
        
        APIManager.sharedManager.getImageList { (array, error) in
            
            if let array = array {
                
                self.dataAr = array
                print(self.dataAr)
                self.collectionView?.reloadData()
            }
        }
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
        
        
        
        
      //  let resource = ImageResource(downloadURL: url!, cacheKey: "my_cache_key")
       
        if !self.dataAr.isEmpty {
            let dict = self.dataAr[indexPath.row] as! Dictionary<String, Any>
            let urls = dict["urls"] as! Dictionary<String, Any>
            let str = urls["small"] as! String
            let url = URL(string: str)
            cell.imageView.kf.setImage(with: url)
        }
        
        return cell
    }
}
