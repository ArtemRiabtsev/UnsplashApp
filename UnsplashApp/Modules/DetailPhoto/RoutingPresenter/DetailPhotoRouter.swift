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

    static func createModuleWithImage(id: String, image: UIImage) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let view = storyboard.instantiateViewController(withIdentifier: "DetailPhotoViewController") as! DetailPhotoViewProtocol
        
        let interactor = DetailPhotoInteractor()
        let router = DetailPhotoRouter()
        let presenter = DetailPhotoPresenter(interface: view,
                                             interactor: interactor,
                                             router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view as? UIViewController
        view.presenter?.setUpView(id: id, image: image)
 
        return view as! UIViewController
    }
    /*
    func dismissDetail() {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
 */
}
