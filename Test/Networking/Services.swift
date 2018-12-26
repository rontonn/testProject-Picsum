//
//  Services.swift
//  Test
//
//  Created by Anton Romanov on 01/11/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import Foundation
import AlamofireImage
import Alamofire
import SwiftyJSON

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

class Services {
    
    static let shared = Services()
    
    func getPlaceholderImage(completion: @escaping (UIImage?, PicsumError?) -> Void) {
        
        Alamofire.request(URL(string: "https://picsum.photos/300")!).responseImage { response in
            
            if let e = response.error {
                completion(nil, .requestFailed(e))
                return
            }
            guard let status = response.response?.statusCode else {
                completion(nil, .noStatus)
                return
            }
            switch status {
            case 404:
                completion(nil, .noStatus)
            case 200:
                guard let image = response.result.value else {
                    completion(nil, .noStatus)
                    return
                }
                completion(image, nil)
                
            default:
                completion(nil, .noStatus)
            }
        }
    }
    
    func fetchPicsumImage(completion: @escaping ([PicsumImage], PicsumError?) -> Void) {
        
        Alamofire.request(URL(string: "https://picsum.photos/list")!).responseJSON { response in
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
                
                if let arrayOfNotParsedData = try? JSON(data: data) {
                
                    var images = [PicsumImage]()
                    for data in arrayOfNotParsedData.arrayValue {
                        images.append(PicsumImage().parse(with: data))
                    }
                    completion(images, nil)
                    
                } else {
                    completion([PicsumImage](), .noStatus)
                }
                
                
            default:
                completion([PicsumImage](), .noStatus)
            }
        }
        
    }
}
