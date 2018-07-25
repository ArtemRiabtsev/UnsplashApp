//
//  Entities.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 25.06.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

typealias Images = [ImageInfo]

struct ImageInfo: Codable  {
    let id: String
    let likes: Int
    let urls: URLS
    let user: User
}

struct Photo {
    let image: UIImage
}

struct URLS: Codable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
}
struct User: Codable {
    let name: String
    let total_photos: Int
    
}
struct SearchObject: Codable {
    let total: Int
    let total_pages: Int
    let results: Images

}
