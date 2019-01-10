//
//  GreetingViewController.swift
//  Test
//
//  Created by Anton Romanov on 24/10/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import UIKit


class GreetingViewController: BaseViewController {
    
    @IBOutlet weak var lblGreeting: UILabel!
    @IBOutlet weak var textViewForPrefferedNumber: UITextField!
    @IBOutlet weak var btnProceed: UIButton!
    
    private var greetingModel = GreetingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        btnProceed.layer.cornerRadius = 8.0
        textViewForPrefferedNumber.delegate = self
        
        greetingModel.btnProceedActive.bind { [unowned self] isActive in
            self.btnProceed.alpha = isActive ? 1.0 : 0.5
        }
        
        greetingModel.error.bind { error in
            guard let e = error else { return }
            DispatchQueue.main.async {[unowned self] in
                self.displayAlertWithOneAction(titleForAlert: "Error.", message: e.localizedDescription)
            }
        }
        
        greetingModel.segueIdentifierToPerform.bind {[unowned self] identifier in
            
            guard let id = identifier else { return }
            DispatchQueue.main.async {[unowned self] in
                self.performSegue(withIdentifier: id , sender: self)
            }
        }

    }
    
    override func createViewModel() {
        commmonTypeViewModel = greetingModel
    }
    
    @objc func dismissKeyboard() {
        textViewForPrefferedNumber.endEditing(true)
    }

    @IBAction func btnProceedAction(_ sender: UIButton) {
        greetingModel.btnProceedTrigger()
    }
}



//MARK: - TextField Delegates
extension GreetingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let userInput = (text as NSString).replacingCharacters(in: range, with: string)
        
        greetingModel.changeNumberOfPictures(with: userInput)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textViewForPrefferedNumber.endEditing(true)
        return true
    }
    
}
