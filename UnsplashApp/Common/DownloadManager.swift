//
//  DownloadModel.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 26.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

class DownloadManager: NSObject {
    
    weak var delegate: DownloadDelegate?
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "background")
        configuration.isDiscretionary = true
        
        return URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
    }()
    
    var progress: Float = 0.0 {
        didSet {
            updateProgress()
        }
    }
    // Gives float for download progress - for delegate
    
    private func updateProgress() {
        print("Update progress DownloadModel")
        delegate?.downloadProgressUpdate(for: progress)
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
    
    func downloadFinished() -> Void {
        self.delegate?.downloadFinished()
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
          //  self.downloadFinished()
        }
    }
    
   func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
        if (downloadTask.originalRequest?.url?.absoluteString) != nil {
            print("PROCESSING")
            self.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        }
    }
}
//MARK: - URLSessionDownloadDelegate
extension DownloadManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        /// lets coding
     //   print("FINISH")
      //  print(location.absoluteString)
        
        do {
            let data = try Data(contentsOf: location)
            let image = UIImage(data: data)
            //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
            UIImageWriteToSavedPhotosAlbum(image!, downloadFinished(), nil, nil)
        } catch  {
            print(error)
            return
        }

        try? FileManager.default.removeItem(at: location)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        debugPrint("Task completed: \(task), error: \(String(describing: error))")
    }
    
}
