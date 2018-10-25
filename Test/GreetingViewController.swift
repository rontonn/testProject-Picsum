//
//  GreetingViewController.swift
//  Test
//
//  Created by Anton Romanov on 24/10/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import UIKit
import AlamofireImage

let imageCache = AutoPurgingImageCache(
    memoryCapacity: 100_000_000,
    preferredMemoryUsageAfterPurge: 60_000_000
)

class GreetingViewController: UIViewController {
    @IBOutlet weak var lblGreeting: UILabel!
    @IBOutlet weak var textViewForPrefferedNumber: UITextField!
    @IBOutlet weak var btnProceed: UIButton!
    var downloadedListOfImages = [PicsumImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        btnProceed.layer.cornerRadius = 8.0
        textViewForPrefferedNumber.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        textViewForPrefferedNumber.endEditing(true)
    }

    @IBAction func btnProceedAction(_ sender: UIButton) {
        view.isUserInteractionEnabled = false
        if textViewForPrefferedNumber.text?.count == 0 {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: "Please type preffered number!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.view.isUserInteractionEnabled = true
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let number = Int(textViewForPrefferedNumber.text!), number > 0 {
                
                Picsum.fetchPicsumImage { [weak self] (images, error) -> (Void) in
                    if let e = error {
                        print("Error happend! - \(e)")
                    } else {
                        self?.downloadedListOfImages = images
                        self?.performSegue(withIdentifier: "fromGreetingScreenToMainViewScreen", sender: self)
                    }
                }
                
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: "Please input positive integer number!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.view.isUserInteractionEnabled = true
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromGreetingScreenToMainViewScreen" {
            let controller = segue.destination as! MainViewController
            
            let numberOfImages = Int(textViewForPrefferedNumber.text!)!
            var numberOfSectionsInTheTable = 0
            var arrayForCollectionViewCells = [Int]()
            var imagesForCollectionView = [[PicsumImage]]()
            
            //solving logic for arranging images in the table and collection view
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
                arrayForCollectionViewCells.append(numberOfImages - arrayForCollectionViewCells.reduce(0, { $0 + $1 }) )
                
            } else {
                arrayForCollectionViewCells.append(numberOfImages)
            }
            //
            
            for numberOfElementsInCollectionView in arrayForCollectionViewCells {
                var tempArray = [PicsumImage]()
                
                for _ in 0...numberOfElementsInCollectionView - 1 {
                    tempArray.append(downloadedListOfImages.randomElement()!)
                }
                imagesForCollectionView.append(tempArray)
                tempArray.removeAll()
                
            }
            
            controller.downloadedListOfPrefferedNumberOfImages = imagesForCollectionView
            textViewForPrefferedNumber.text = ""
        
        }
    }
}



//MARK: - TextField Delegates
extension GreetingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textViewForPrefferedNumber.placeholder = ""
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text?.count == 0 {
            textViewForPrefferedNumber.placeholder = "Please type preffered number"
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
