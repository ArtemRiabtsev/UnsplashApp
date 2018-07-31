//
//  DetailPhotoViewController.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController, DetailPhotoViewProtocol {
    
    var photoSize = ""
    
    var imageViewSize: CGSize? = nil
    
    var scale: (w: CGFloat, h: CGFloat) {
        
        return ((imageViewSize?.width)! / self.detailImageView.frame.size.width, (imageViewSize?.height)! / self.detailImageView.frame.size.height)
    }
    
    
    var photoID: String? = nil
    
    var presenter: DetailPhotoPresenterProtocol?

    @IBOutlet weak var detailImageView: UIImageView!
    
    var popoverController: PopoverViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadImage))
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.presenter?.router?.dismissDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
   
    //MARK: ACTIONS
    @IBAction func panView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            
            let point = CGPoint(x:view.center.x + translation.x,
                                y:view.center.y + translation.y)
            
            view.center = point
        }
        sender.setTranslation(CGPoint.zero, in: self.view)

    }
    @IBAction func viewPinch(_ sender: UIPinchGestureRecognizer) {
        if let view = sender.view {
            if view.frame.width < 100 {
                return
            }
            setTitleWidthHeight()
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
        
    }
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        if let view = sender.view {
            if view.frame.size.height < (self.view.window?.frame.height)! {
                
                view.transform = view.transform.scaledBy(x: 1.5, y: 1.5)
                setTitleWidthHeight()
            }
        }
    }
    @objc func downloadImage(sender: UIBarButtonItem) -> Void {
        
        let alert = UIAlertController(title: "Download photo?", message: "Size: \(size)", preferredStyle: .alert)
        
        let okAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            self.stardDownload()
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
        }
        alert.addAction(okAlertAction)
        alert.addAction(cancelAlertAction)
        
        self.present( alert, animated: true, completion: nil)
    }
    
    //MARK: support func
    //
    
    func creatPopoverController() -> UIViewController {
        
        let popController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopoverController")
        popController.modalPresentationStyle = .popover
        popController.popoverPresentationController?.delegate = self
        return popController
    }
    
    // 
    func stardDownload() {
        let size = calculateWidthHeight()
        
        self.popoverController = creatPopoverController() as? PopoverViewController
        
        self.present(self.popoverController!, animated: true, completion: nil)
        self.presenter?.interactor?.downloadPhotoWithCustomSize(id: self.photoID!, size: size)
        
    }
    func setTitleWidthHeight() -> Void {
        
        let size = calculateWidthHeight()
        self.navigationItem.title = "w: \(size.width) h: \(size.height)"
    }
    func calculateWidthHeight() -> CGSize {
        
        let height = (self.detailImageView.image?.size.height)! / self.scale.h
        let width = (self.detailImageView.image?.size.width)! / self.scale.w
        let size = CGSize(width: Int(width), height: Int(height))
        
        return size
    }
    
}


//MARK: Detail Photo View Protocol
extension DetailPhotoViewController {
    func showPhoto(viewModel: SingleViewModel) {
        
        self.imageViewSize = self.detailImageView.frame.size
        
        self.photoID = viewModel.imageByID?.id
        
        let image = viewModel.photo?.image
        
        self.detailImageView.image = image
        setTitleWidthHeight()
    }
    
    func showDownloadProgress(progress: Float) {        

        DispatchQueue.main.async {
            self.popoverController?.progressView.setProgress(progress, animated: true)
        }
    }
    func showDownloadInfo(info: String) {
        
        let alert = UIAlertController(title: info, message: nil, preferredStyle: .alert)
        
        let okAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
        }
        
        alert.addAction(okAlertAction)
        DispatchQueue.main.async {
            self.popoverController?.dismiss(animated: true, completion: nil)
            let viewController = self.navigationController?.topViewController
            viewController?.present(alert, animated: true, completion: nil)
            alert.view.center = (viewController?.view.center)!
        }
   }
}
//MARK: UIPopover Presentation Controller Delegate

extension DetailPhotoViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.permittedArrowDirections = [.up, .right]
     //   popoverPresentationController.sourceView = self.view
      //  popoverPresentationController.sourceRect = CGRect(x: Int(self.view.frame.maxX - 150), y: Int(self.view.frame.minY), width: 140, height: 60)
        popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem
    }
     func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
        view.pointee = self.view
        rect.pointee = self.view.bounds
    }
}
