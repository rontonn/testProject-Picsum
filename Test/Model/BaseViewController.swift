//
//  BaseViewController.swift
//  Test
//
//  Created by Anton Romanov on 26/12/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {

    var commmonTypeViewModel:BaseViewModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is BaseViewController) {
            let destVC = segue.destination as! BaseViewController
            destVC.commmonTypeViewModel?.passedObject.value = commmonTypeViewModel?.passingObject
        }
    }
    
    func createViewModel() {
        fatalError("Override createViewModel() without call super")
    }
}
