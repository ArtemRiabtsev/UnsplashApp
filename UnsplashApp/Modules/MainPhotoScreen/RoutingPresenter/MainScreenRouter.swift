//
//  MainScreenRouter.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class MainScreenRouter: MainScreenWireframeProtocol {
    
    weak var viewController = UIViewController() ///  --- ?????????????????????????????????????????? dependency injection

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let view = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewProtocol
        
        let interactor = MainScreenInteractor()
        let router = MainScreenRouter()
        let presenter = MainScreenPresenter(interface: view,
                                            interactor: interactor,
                                            router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view as? UIViewController

        return view as! UIViewController
    }

    func pushDetailWithSelectedPhoto(photoID: String, image: UIImage) {
        let detailViewController = DetailPhotoRouter.createModuleWithImage(id: photoID, image: image)
        self.viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
