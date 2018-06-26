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

    func getImageList() {
        
        MainScreenInteractor.loadImageList { (array) in
            self.presenter?.didLoadList(imageList: array!)
        }
    }
    //load data from network
    static func loadImageList(handler: @escaping(Array<ImageInfo>?) -> ()) {
        
        APIManager.sharedManager.getImageList { (array, error) in
            
            if let array = array {
                
                handler(array as? Array<ImageInfo>)
            }else{
                
                print(error!.localizedDescription)
            }
        }
    }
}
