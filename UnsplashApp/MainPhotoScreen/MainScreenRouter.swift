//
//  MainScreenRouter.swift
//  Unsplash
//
//  Created by Артем Рябцев on 22.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class MainScreenRouter: MainScreenWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewProtocol
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

}
//UIStoryboard storyboardWithName:@"Detail" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
