//
//  MainScreenProtocols.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol MainScreenWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol MainScreenPresenterProtocol: class {

    var interactor: MainScreenInteractorInputProtocol? { get set }
    var view: MainScreenViewProtocol? { get set }
    var router: MainScreenWireframeProtocol? { get set }
    
    func setUpView(page: Int)
    func setUpViewWithSearchResult(page: Int, keyword: String)
}

// MARK: InteractorProtocol

protocol MainScreenInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    
    func didLoadList(imageList: [ImageInfo])
    func didLoadImagesByKeyword(imageList: [ImageInfo])
}

protocol MainScreenInteractorInputProtocol: class {

    var presenter: MainScreenInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getImageList(page: Int)
    func searchImagesByKeyword(page: Int, keyword: String)
}

// MARK: ViewProtocol

protocol MainScreenViewProtocol: class {

    var presenter: MainScreenPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func showImageList(imageList: [ImageInfo])
    func showSearchResultImageList(imageList: [ImageInfo])
}
