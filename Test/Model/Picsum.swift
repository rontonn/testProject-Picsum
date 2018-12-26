//
//  Picsum.swift
//  Test
//
//  Created by Anton Romanov on 24/10/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import Foundation
import SwiftyJSON

class PicsumImage {
    var format: String = ""
    var width: Int = 0
    var height: Int = 0
    var filename: String = ""
    var id: Int = 0
    var author: String = ""
    var authorURL: String = ""
    var postURL: String = ""
    
    func parse(with data: JSON) -> PicsumImage {
        format = data["format"].stringValue
        width = data["width"].intValue
        height = data["height"].intValue
        filename = data["filename"].stringValue
        id = data["id"].intValue
        author = data["author"].stringValue
        authorURL = data["author_url"].stringValue
        postURL = data["post_url"].stringValue
        
        return self
    }
}

