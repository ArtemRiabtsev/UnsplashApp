//
//  MainScreenProtocols.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

// MARK: WireFrameProtocol

protocol MainScreenWireframeProtocol: class {
    static func createModule() -> UIViewController
    func pushDetailWithSelectedPhoto(photoID: String, image: UIImage)
}

// MARK: PresenterProtocol

protocol MainScreenPresenterProtocol: class {

    var interactor: MainScreenInteractorInputProtocol? { get set }
    var view: MainScreenViewProtocol? { get set }
    var router: MainScreenWireframeProtocol? { get set }
    
    func setUpView(page: Int)
    func setUpViewWithSearchResult(page: Int, keyword: String)
    func pushDetail(id: String, image: UIImage)
}

// MARK: InteractorProtocol

protocol MainScreenInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    
    func didLoadList(imageList: ListViewModel)
    func didLoadImagesByKeyword(imageList: ListViewModel)
    func loadingIsFailed(errorMessage: String)
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
    func showImageList(imageList: ListViewModel)
    func showLoadingErrorMessage(errorMessage: String)
}
