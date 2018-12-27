//
//  Extensions.swift
//  Test
//
//  Created by Anton Romanov on 01/11/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayAlertWithOneAction(titleForAlert: String, message: String) {
        
        let alert = UIAlertController(title: titleForAlert, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
}
