//
//  MainScreenInteractor.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import Foundation

class MainScreenInteractor: MainScreenInteractorInputProtocol {
    weak var presenter: MainScreenInteractorOutputProtocol?

    func getImageList(page: Int) {
        
        MainScreenInteractor.loadImageList(page: page) { (array) in
            self.presenter?.didLoadList(imageList: array!)
        }
    }
    
    func searchImagesByKeyword(page: Int, keyword: String) {
        MainScreenInteractor.loadSearchResultImageList(page: page, keyword: keyword) { (array) in
            self.presenter?.didLoadImagesByKeyword(imageList: array!)
        }
    }
    

    //load data from network
    static func loadImageList(page: Int, handler: @escaping(Array<ImageInfo>?) -> ()) {
        
        APIManager.sharedManager.getImageList(page: page) { (array, error) in
            
            if let array = array {
                
                handler(array as? Array<ImageInfo>)
            }else{
                
                print(error!.localizedDescription)
            }
        }
    }
    static func loadSearchResultImageList(page: Int, keyword: String, handler: @escaping(Array<ImageInfo>?) -> ()) {
        
        APIManager.sharedManager.searchByKeyword(page: page, keyword: keyword) { (array, error) in
            if array != nil {
                handler(array as? Array<ImageInfo>)
            }else {
                print(error!.localizedDescription)
            }
        }
    }
}
