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

    @IBOutlet var pinchGestureRecognizer: UIPinchGestureRecognizer!
    @IBOutlet weak var imageView: UIImageView!
  ///  var pinchGesture = UIPinchGestureRecognizer()
    
        // @IBOutlet weak var scrollView: UIScrollView!
        // @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    ///   pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchedView))
    ///   imageView.addGestureRecognizer(pinchGesture)
        //   self.scrollView.minimumZoomScale = 0.3
        //   self.scrollView.maximumZoomScale = 1.0
    }
/*//////
    @objc func pinchedView(sender:UIPinchGestureRecognizer){
        self.view.bringSubview(toFront: imageView)
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
 */////

    @IBAction func pinchView(_ sender: UIPinchGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }
 
}
//MARK: UIScrollView delegate
extension DetailPhotoViewController: UIScrollViewDelegate {
    /*
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
    }
 */
}
