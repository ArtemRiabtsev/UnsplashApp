//
//  DetailPhotoProtocols.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

// MARK: WireFrameProtocol

protocol DetailPhotoWireframeProtocol: class {
    static func createModuleWithImage(id: String, image: UIImage) -> UIViewController
//    func dismissDetail()
}

// MARK: PresenterProtocol

protocol DetailPhotoPresenterProtocol: class {
    var interactor: DetailPhotoInteractorInputProtocol? { get set }
    var view: DetailPhotoViewProtocol? { get set }
    var router: DetailPhotoWireframeProtocol? { get set }
    func setUpView(id: String, image: UIImage)
    func downloadPhotoByIdWithSize(id: String, size: CGSize)
}

// MARK: InteractorProtocol
protocol DownloadDelegate: class {
    func downloadProgressUpdate(for progress: Float)
    func downloadFinished(info: String)
    func downloadingIsFailed(_ error:Error)
}

protocol DetailPhotoInteractorOutputProtocol: class {

    func downloadProgress(progress: Float)
    func downloadFinished(info: String)
    func downloadFeiled(errorMessage: String)
    /** Interactor -> Presenter */
}

protocol DetailPhotoInteractorInputProtocol: class {

    var presenter: DetailPhotoInteractorOutputProtocol? { get set }
    
    func downloadPhotoWithCustomSize(id: String, size: CGSize)
    
    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol DetailPhotoViewProtocol: class {

    var presenter: DetailPhotoPresenterProtocol? { get set }
    
    /** Presenter -> ViewController */
    var sendedImage: UIImage? { get set }
    var id: String? { get set }
    
    func showDownloadProgress(progress: Float)
    func showDownloadInfo(info: String)
    func showErrorMessage(errorMessage: String)
    func showImage(id: String, image: UIImage)
}
