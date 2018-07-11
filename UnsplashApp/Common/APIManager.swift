//
//  APIManager.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import Foundation
import UIKit

class APIManager {
    
    static let sharedManager = APIManager()
    let client_id = "client_id=78c7330e50470f59f78af971a2b3fa9dd93be90e05f83c1679c0f109d541cdc9"
    let apiLocation = "https://api.unsplash.com/"
    
    var pageCount: Int = 0
    let session = URLSession.shared
    var pathToPhotoList: String{
        return "\(apiLocation)photos?\(client_id)&page="
    }
    var pathToSearch: String {
        return "\(apiLocation)search/photos?\(client_id)&page="
    }
    

    func getImageList(page: Int, handler: @escaping(Array<Any>?, Error?) -> ()) -> (){
        
        let urlComponents = URLComponents(string: pathToPhotoList + String(page))
        
        guard let url = urlComponents?.url else { return }
        
        print(url.absoluteString)
        
        let task = session.dataTask(with: url) { (data, respons, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    handler(nil,error)
                }
            }else{
                do {
                    let array = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<Any>
                    let result = APIManager.getFieldsFromAllInfo(array: array)
                    DispatchQueue.main.async {
                        handler(result, nil)
                    }
                } catch {
                    return
                }
            }
        }
        task.resume()
    }
    
    func searchByKeyword(page: Int, keyword: String, handler: @escaping(Array<Any>?, Error?) -> ()) -> () {
        let urlComponents = URLComponents(string: pathToSearch + String(page) + "&query=\(keyword)")
        
        guard let url = urlComponents?.url else { return }
        
        print(url.absoluteString)
        
        let task = session.dataTask(with: url) { (data, respons, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    handler(nil,error)
                }
            }else{
                do {
                    let dict = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                    print("PAGES TOTAL\(dict["total_pages"] as! NSNumber)")
                    let array = dict["results"] as! Array<Any>
                    let result = APIManager.getFieldsFromAllInfo(array: array)
                    DispatchQueue.main.async {
                        handler(result, nil)
                    }
                } catch {
                    return
                }
            }
        }
        task.resume()
    }
}
//MARK: extension processes data from the network and takes the necessary values
extension APIManager {
    
    static func getFieldsFromAllInfo(array: Array<Any>) -> [ImageInfo] {
    
        var resultArray = Array<ImageInfo>()
        
        if !array.isEmpty {
            for item in array {
                
                if item is Dictionary<String, Any> {
                    
                    let dictionary = item as! Dictionary<String, Any>
                    
                    let userInfo = dictionary["user"] as? Dictionary<String, Any>
                    
                    /// get image from url
                    let dict = dictionary["urls"] as! Dictionary<String, Any>
                    let url = URL(string: dict["small"] as! String)
                    var imgFromNetwork: UIImage!
                    
                    if let data = try? Data(contentsOf: url!) {
                        if let img = UIImage(data: data) {
                            DispatchQueue.main.async {
                                imgFromNetwork = img
                            }
                        }
                    }
                    ///
                    let image = ImageInfo(imageID: dictionary["id"] as? String,
                                          likes: dictionary["likes"] as? Int,
                                          urls: dictionary["urls"] as? Dictionary<String, Any>,
                                          image:imgFromNetwork,
                                          userName: userInfo!["name"] as? String)
                    
                    
                    resultArray.append(image)
                }
            }
        }
        
        return resultArray
    }
}
