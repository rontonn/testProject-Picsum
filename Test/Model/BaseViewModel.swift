//
//  BaseViewModel.swift
//  Test
//
//  Created by Anton Romanov on 26/12/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import Foundation

class BaseViewModel {
    var passingObject: Any? = nil
    var passedObject: Box<Any?> = Box(nil)
    
    init() {
        passedObject.bind { [unowned self] value in
            self.handlePassedObject(value: value)
        }
    }
    
    func handlePassedObject(value: Any?) {
        // do something with passed object
    }
}
