//
//  DetailPhotoViewController.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController, DetailPhotoViewProtocol {
    
    

    var presenter: DetailPhotoPresenterProtocol?

    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadImage))
    }

    //MARK: ACTIONS
    @IBAction func panView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            
            let point = CGPoint(x:view.center.x + translation.x,
                                y:view.center.y + translation.y)
            
            print(point)
            view.center = point
        }
        sender.setTranslation(CGPoint.zero, in: self.view)

    }
    @IBAction func viewPinch(_ sender: UIPinchGestureRecognizer) {
        if let view = sender.view {
            if view.frame.width < 100 {
                return
            }
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        if let view = sender.view {
            if view.frame.size.height < (self.view.window?.frame.height)! {
                view.transform = view.transform.scaledBy(x: 1.5, y: 1.5)
            }
        }
    }
    @objc func downloadImage(sendet: UIBarButtonItem) -> Void {
        print("downloadImage")
        
    }
}


//MARK: Detail Photo View Protocol
extension DetailPhotoViewController {
    func showPhoto(viewModel: SingleViewModel) {
        
        let image = viewModel.photo?.image
        self.detailImageView.image = image
     //   self.detailImageView.frame = CGRect(x: self.detailImageView.frame.origin.x, y: self.detailImageView.frame.origin.y, width: image!.size.width, height: image!.size.height)
    }
}
