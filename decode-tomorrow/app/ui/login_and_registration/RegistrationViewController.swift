//
//  RegistrationViewController.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, Storyboarded {
    
    static var storyboardId: String = "RegistrationViewController"
    static var storyboard: String = "LoginAndRegistration"
    
    // MARK: - Outlets
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    // END OUTLETS
    
    var feature: RegistrationFeature?
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initFeature()
    }
    
    private func initViews() {
        phoneNumberTextField.style()
        passwordTextField.style()
        confirmPasswordTextField.style()
        emailTextField.style()
        nameTextField.style()
        addressTextField.style()
        schoolTextField.style()
        registerButton.style()
        #if DEBUG
        mockInput()
        #endif
    }
    
    private func initFeature() {
        self.feature = RegistrationFeature(self)
    }
    
    // MARK: - Actions
    func mockInput() {
        self.phoneNumberTextField.text = "09100000000"
        self.passwordTextField.text = "password"
        self.confirmPasswordTextField.text = "password"
        self.emailTextField.text = "mark.rufino.io+01@gmail.com"
        self.nameTextField.text = "Mark Alain D. Rufino"
        self.addressTextField.text = "Metrowalk"
        self.schoolTextField.text = "UA"
    }
    
    @IBAction func didTapConfirmButton(_ sender: Any) {
 
        let hc = "student"
        
        guard let mobileNumber = phoneNumberTextField.text?.trim() else {
            return
        }
        
        guard let password = passwordTextField.text?.trim() else {
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text?.trim() else {
            return
        }
        
        guard password == confirmPassword else {
            showAlert(.error, message: "Passwords didn't match!")
            return
        }
        
        guard let email = emailTextField.text?.trim() else {
            return
        }
        
        guard let name = nameTextField.text?.trim() else {
            return
        }
        
        guard let address = addressTextField.text?.trim() else {
            return
        }
        
        guard let school = schoolTextField.text?.trim() else {
            return
        }
        
        let inputs = [mobileNumber, password, confirmPassword, email, name, address, school]
        let hasAnEmptyInput = inputs.filter { $0 == "" }.count != 0
        
        guard !hasAnEmptyInput else {
            showAlert(.error, message: "All fields are required!")
            return
        }
        
        showHUD()
        
        let params = RegistrationParams(
            role: hc,
            mobileNumber: mobileNumber,
            password: password,
            email: email,
            name: name,
            address: address,
            school: school
        )
        
        self.feature?.register(params)
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        feature?.detach()
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension RegistrationViewController: RegistrationFeatureDelegate {
    
    func registrationSuccess(_ viewModel: RegistrationViewModel) {
        hideHUD()
        let params = LoginParams.init(email: emailTextField.text!.trim(), password: passwordTextField.text!.trim())
        CredentialsManager.shared.store(params)
        self.navigate(to: .documentUpload)
    }
    
    func registrationError(error: String) {
        hideHUD()
        showAlert(.error, message: error)
    }
    
}
