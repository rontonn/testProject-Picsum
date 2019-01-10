//
//  GreetingViewModel.swift
//  Test
//
//  Created by Anton Romanov on 01/11/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import Foundation
import UIKit

class GreetingViewModel: BaseViewModel {
    var downloadedListOfImages = [PicsumImage]()
    var placeholderImage = UIImage()
    
    let numberOfPictures: Box<String> = Box("")
    let error: Box<PicsumError?> = Box(nil)
    let btnProceedActive: Box<Bool> = Box(false)
    let segueIdentifierToPerform: Box<String?> = Box(nil)
    
    private var placeholderImageHasBeenDownloaded = false
    private var listWithImagesHasBeenDownloaded = false
    
    override init() {
        super.init()
        
        getPlaceholder()
    }
    
    func getPlaceholder() {
        Services.shared.getPlaceholderImage { [unowned self] (image, errorMessage) in
            if let placeholder = image {
                self.placeholderImage = placeholder
                self.placeholderImageHasBeenDownloaded = true
                print(" Placeholder is downloaded.\n")
                self.getListOfImages()
            } else if let e = errorMessage {
                self.error.value = e
            }
        }
    }
    
    func getListOfImages() {
        Services.shared.fetchPicsumImage { [unowned self] (images, error) -> (Void) in
            if let e = error {
                self.error.value = e
            } else {
                self.downloadedListOfImages = images
                self.listWithImagesHasBeenDownloaded = true
                print(" List is downloaded.\n")
            }
        }
    }
    
    func btnProceedTrigger() {
        prepareImagesForCollectionViewOnNextScreen()
    }
    
    private func prepareImagesForCollectionViewOnNextScreen() {
        var numberOfImages = 0
        
        if let number = Int(numberOfPictures.value) {
            numberOfImages = number
        }
        
        var numberOfSectionsInTheTable = 0
        var arrayForCollectionViewCells = [Int]()
        var imagesForCollectionView = [[PicsumImage]]()
        
        if numberOfImages > downloadedListOfImages.count {
            numberOfImages = downloadedListOfImages.count
        }
        //logic for arranging images in a nice way in the table and collection view
        if numberOfImages > 50 {
            
            numberOfSectionsInTheTable = 10
            
            for i in 0...numberOfSectionsInTheTable - 1 {
                if i == numberOfSectionsInTheTable - 1 {
                    arrayForCollectionViewCells.append(numberOfImages - arrayForCollectionViewCells.reduce(0, { $0 + $1 }) )
                } else {
                    arrayForCollectionViewCells.append(Int((Double(numberOfImages) / 10).rounded()))
                }
            }
            
        } else if numberOfImages > 5 {
            numberOfSectionsInTheTable = numberOfImages / 5
            
            for _ in 0...numberOfSectionsInTheTable - 1 {
                arrayForCollectionViewCells.append(5)
            }
            
            let reminder = numberOfImages - arrayForCollectionViewCells.reduce(0, { $0 + $1 })
            if reminder != 0 {
                arrayForCollectionViewCells.append(reminder)
            }
            
        } else {
            arrayForCollectionViewCells.append(numberOfImages)
        }
        //
        
        for numberOfElementsInCollectionView in arrayForCollectionViewCells {
            var tempArray = [PicsumImage]()
            
            for _ in 0...numberOfElementsInCollectionView - 1 {
                if let random = downloadedListOfImages.randomElement() {
                    tempArray.append(random)
                }
            }
            imagesForCollectionView.append(tempArray)
            tempArray.removeAll()
            
        }
        
        passingObject = (placeholderImage: placeholderImage, arrayWithImages: imagesForCollectionView)
        segueIdentifierToPerform.value = "fromGreetingScreenToMainViewScreen"
    }
    
    func changeNumberOfPictures(with text: String) {
        numberOfPictures.value = text
        if text == "" {
            btnProceedActive.value = false
        } else {
            if listWithImagesHasBeenDownloaded && placeholderImageHasBeenDownloaded {
                btnProceedActive.value = true
            }
        }
    }
    
}
