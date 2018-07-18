//
//  DetailPhotoRouter.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class DetailPhotoRouter: DetailPhotoWireframeProtocol {
    

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailPhotoViewController") as! DetailPhotoViewController
        let interactor = DetailPhotoInteractor()
        let router = DetailPhotoRouter()
        let presenter = DetailPhotoPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
    
    func dismissDetail() {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
}
