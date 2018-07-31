//
//  DownloadModel.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 26.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class DownloadManager: NSObject {
    
    
    var delegate: DownloadDelegate?
    
    private var session: URLSession  {
        
        
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "background")
        configuration.isDiscretionary = true
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
        
        return session
    }
    
    var progress: Float = 0.0 {
        didSet {
            updateProgress()
        }
    }
    // Gives float for download progress - for delegate
    
    private func updateProgress() {
        self.delegate?.downloadProgressUpdate(for: self.progress)
        if progress == 1 {
            progress = 0.0
        }
    }
    
    init(delegate:DownloadDelegate) {

        self.delegate = delegate
    }
    
    //////////// Download
    
    func download(path: String) -> Void {
        
        let url = URL(string: path)
                
        let task = self.session.downloadTask(with:url!)
        
        task.resume()
    }
    
    func downloadFinished(info: String) -> Void {
        self.delegate?.downloadFinished(info: info)
    }
    
    
}
//MARK: - URLSessionDelegate
extension DownloadManager: URLSessionDelegate {
    //To call completion
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let backgroundCompletionHandler =
                appDelegate.backgroundSessionCompletionHandler else {
                    return
            }
            backgroundCompletionHandler()
        }
    }
    // update progress view
   func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                   didWriteData bytesWritten: Int64,
                   totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
    print(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
        if totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown {
            
            self.progress += 0.5
        } else {
            self.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        }
    }
}
//MARK: - URLSessionDownloadDelegate
extension DownloadManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        
        do {
            let data = try Data(contentsOf: location)
            let img = UIImage(data: data)
            let info = "Image saved"
            UIImageWriteToSavedPhotosAlbum(img!, downloadFinished(info: info),  nil, nil)
            
        } catch  {
            downloadFinished(info: error.localizedDescription)
            return
        }
        downloadTask.cancel()
        try? FileManager.default.removeItem(at: location)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let error = error {
            print(error)
            self.downloadFinished(info: error.localizedDescription)
        } else {
            session.invalidateAndCancel()
        }
       // debugPrint("Task completed: \(task), error: \(String(describing: error))")
    }
}
