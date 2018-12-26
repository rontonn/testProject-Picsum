//
//  PicsumViewModel.swift
//  Test
//
//  Created by Anton Romanov on 26/12/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import Foundation
import UIKit

class PicsumViewModel: BaseViewModel {
    var listOfPrefferedNumberOfImages = [[PicsumImage]]()
    var placeholder = UIImage()

    let segueIdentifierToPerform: Box<String?> = Box(nil)

    override func handlePassedObject(value: Any?) {
        if let incomingData = value as? (placeholderImage: UIImage, arrayWithImages: [[PicsumImage]]) {
            placeholder = incomingData.placeholderImage
            listOfPrefferedNumberOfImages = incomingData.arrayWithImages
        }
    }
    
    
}
