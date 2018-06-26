//
//  APIManager.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import Foundation
class APIManager {
    
    static let sharedManager = APIManager()
    let client_id = "client_id=78c7330e50470f59f78af971a2b3fa9dd93be90e05f83c1679c0f109d541cdc9"
    let apiLocation = "https://api.unsplash.com/"
    
    var pageCount: Int = 0
    let session = URLSession.shared
    var pathToPhotoList: String{
        return "\(apiLocation)photos?\(client_id)&page=\(pageCount)"
    }

    func getImageList(handler: @escaping(Array<Any>?, Error?) -> ()) -> (){
        pageCount += 1
        let urlComponents = URLComponents(string: pathToPhotoList)
        
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
}
//MARK: extension processes data from the network and takes the necessary values
extension APIManager {
    
    static func getFieldsFromAllInfo(array: Array<Any>) -> [ImageInfo] {
        
        var resultArray = Array<ImageInfo>()
        
        if !array.isEmpty {
            for item in array {
                
                if item is Dictionary<String, Any> {
                    
                    let dictionary = item as! Dictionary<String, Any>
                    
                    
                    let image = ImageInfo(imageID: dictionary["id"] as? String,
                                          likes: dictionary["likes"] as? Int,
                                          urls: dictionary["urls"] as? Dictionary<String, Any>)
                    resultArray.append(image)
                }
            }
        }
        
        return resultArray
    }
}
