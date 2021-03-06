//
//  DetailPhotoViewController.swift
//  Unsplash
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController, DetailPhotoViewProtocol {
    // - - DetailPhotoViewProtocol -stored properties
    var id: String?
    
    var sendedImage: UIImage?
    
    var presenter: DetailPhotoPresenterProtocol?
    
    var imageViewSize: CGSize?
    
    var resizedImageSize: CGSize {

        let height = (self.detailImageView.image?.size.height)! / self.scale.h
        let width = (self.detailImageView.image?.size.width)! / self.scale.w
        let size = CGSize(width: Int(width), height: Int(height))
        return size
    }
    
    var scale: (w: CGFloat, h: CGFloat) {
        
        return ((imageViewSize?.width)! / self.detailImageView.frame.size.width, (imageViewSize?.height)! / self.detailImageView.frame.size.height)
    }
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    var popoverController: PopoverViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let barButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadImage))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        self.detailImageView.image = sendedImage
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.imageViewSize = self.detailImageView.frame.size
        setTitleWidthHeight()
    }
    
    //MARK: ACTIONS
    // gestures actions
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
    // download action
    @objc func downloadImage(sender: UIBarButtonItem) -> Void {
        
        let alert = UIAlertController(title: "Download photo?", message: "Size: \(self.resizedImageSize)", preferredStyle: .alert)
        
        let okAlertAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            self.stardDownload()
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
        }
        alert.addAction(okAlertAction)
        alert.addAction(cancelAlertAction)
        
        self.present( alert, animated: true, completion: nil)
    }
    
    //MARK: accessory func
    //
    func creatPopoverController() -> UIViewController {// creat a popover with indicator and progress
        
        let popController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopoverController")
        popController.modalPresentationStyle = .popover
        popController.popoverPresentationController?.delegate = self
        return popController
    }
    
    // 
    func stardDownload() { // present popover and 
        
        self.popoverController = creatPopoverController() as? PopoverViewController
        
        self.present(self.popoverController!, animated: true, completion: nil)
        
        self.presenter?.downloadPhotoByIdWithSize(id: id!, size: self.resizedImageSize)
    }
    
    func setTitleWidthHeight()  {// updated title when size chaged
        
        self.navigationItem.title = "w: \(self.resizedImageSize.width) h: \(self.resizedImageSize.height)"
    }
    
    func alertFuncWithOK(title: String, message: String?) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        return alert
    }
}

//MARK: Detail Photo View Protocol
extension DetailPhotoViewController {
   
    func showDownloadProgress(progress: Float) {        

        DispatchQueue.main.async {
            self.popoverController?.activityIndicator.stopAnimating()
            self.popoverController?.statusLabel.text = "loading..."
            self.popoverController?.progressView.setProgress(progress, animated: true)
        }

    }
    
    func showDownloadInfo(info: String) {
        
        let alert = self.alertFuncWithOK(title: info, message: nil)
        let viewController = self.navigationController?.topViewController
        
        if let popVC = self.popoverController {
            popVC.dismiss(animated: true, completion: {
                viewController?.present(alert, animated: true, completion: nil)
                alert.view.center = (viewController?.view.center)!
            })
        } else {
            viewController?.present(alert, animated: true, completion: nil)
            alert.view.center = (viewController?.view.center)!
        }
        
   }
    func showErrorMessage(errorMessage: String) {
        let alert = self.alertFuncWithOK(title: errorMessage, message: nil)
        if let popVC = self.popoverController {
            popVC.dismiss(animated: true, completion: {
                self.present(alert, animated: true, completion: nil)
            })
        } else {
             self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showImage(id: String, image: UIImage) {

        self.sendedImage = image
        self.id = id
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

//MARK: UIPopover Presentation Controller Delegate

extension DetailPhotoViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.permittedArrowDirections = [.up, .right]
        popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem
    }
  
}
