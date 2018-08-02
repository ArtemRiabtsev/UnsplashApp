//
//  DownloadManager.swift
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
        configuration.waitsForConnectivity = true
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
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
}
//MARK: - URLSessionDownloadDelegate
extension DownloadManager: URLSessionDownloadDelegate {
    // update progress view
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
        
        if totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown {
            
            self.progress += 0.33
        } else {
            
            self.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let photoData = try? Data(contentsOf: location) else {
            
            self.delegate?.downloadingIsFailed(APIError.imageDownload)
            return
        }
        guard let photo = UIImage(data: photoData) else {
            self.delegate?.downloadingIsFailed(APIError.imageConvert)
            return
        }
        let info = "Image saved"
        UIImageWriteToSavedPhotosAlbum(photo, downloadFinished(info: info),  nil, nil)
        downloadTask.cancel()
        try? FileManager.default.removeItem(at: location)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let error = error {
            print(error)
            self.delegate?.downloadingIsFailed(error)
        } else {
            session.invalidateAndCancel()
        }
    }
}
