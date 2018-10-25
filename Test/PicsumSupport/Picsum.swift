//
//  Picsum.swift
//  Test
//
//  Created by Anton Romanov on 24/10/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import Foundation
import Alamofire

struct PicsumImage {
    let format: String
    let width: Int
    let height: Int
    let filename: String
    let id: Int
    let author: String
    let authorURL: String
    let postURL: String
    
    init(format: String, width: Int, height: Int, filename: String, id: Int, author: String, authorURL: String, postURL: String) {
        self.format = format
        self.width = width
        self.height = height
        self.filename = filename
        self.id = id
        self.author = author
        self.authorURL = authorURL
        self.postURL = postURL
    }
    /*
     "format": "jpeg",
     "width": 5616,
     "height": 3744,
     "filename": "51492538696.jpg",
     "id": 0,
     "author": "Alejandro Escamilla",
     "author_url": "https://alejandroescamilla.com/",
     "post_url": "https://unsplash.com/post/51492538696/download-by-alejandro-escamilla"
    */
}

enum PicsumError : Error, CustomStringConvertible {
    case requestFailed(Error)
    case noStatus
    
    var description: String {
        switch self {
        case .requestFailed(let e):
            return e.localizedDescription
        case .noStatus:
            return "Could not fetch image"
        }
    }
}

class Picsum {
    
    class func fetchPicsumImage(completion: @escaping ([PicsumImage], PicsumError?) -> (Void)) {
        
        Alamofire.request(URL(string: "https://picsum.photos/list")!).responseJSON { (response) in
            if let e = response.error {
                completion([PicsumImage](), .requestFailed(e))
                return
            }
            guard let status = response.response?.statusCode else {
                completion([PicsumImage](), .noStatus)
                return
            }
            switch status {
            case 404:
                completion([PicsumImage](), .noStatus)
            case 200:
                guard let data = response.data else {
                    completion([PicsumImage](), .noStatus)
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] {
                        var images = [PicsumImage]()
                        for entry in json {
                            
                            if let format = entry["format"], let width = entry["width"], let height = entry["height"], let filename = entry["filename"], let id = entry["id"], let author = entry["author"], let authorURL = entry["author_url"], let postURL = entry["post_url"]  {
                                
                                images.append(PicsumImage(format: format as! String, width: width as! Int, height: height as! Int, filename: filename as! String, id: id as! Int, author: author as! String, authorURL: authorURL as! String, postURL: postURL as! String))
                            }
                        }
                        completion(images, nil)
                    } else {
                        completion([PicsumImage](), .noStatus)
                    }
                } catch let e {
                    completion([PicsumImage](), .requestFailed(e))
                }
            default:
                completion([PicsumImage](), .noStatus)
            }
        }
        
    }
    
}
