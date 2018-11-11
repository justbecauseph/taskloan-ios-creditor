//
//  LoginViewController.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import UIKit

protocol CallsAnApiBehindLogin {
    func callApi(_ loginFeatureDelegate: LoginFeatureDelegate)
}

class LoginViewController: UIViewController, Storyboarded {
    
    static var storyboardId: String = "LoginViewController"
    static var storyboard: String = "LoginAndRegistration"
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    // END OUTLETS
    
    var callsAnApiBehindMe: CallsAnApiBehindLogin?
    var feature: LoginFeature?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFeatures()
        initViews()
    }
    
    private func initFeatures() {
        self.feature = LoginFeature(self)
    }
    
    private func initViews() {
        emailTextField.style()
        passwordTextField.style()
        loginButton.style()
        mockUI()
    }
    
    // MARK: - Actions
    
    func mockUI() {
        emailTextField.text = "student@taskloan.pro"
        passwordTextField.text = "secret"
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        feature?.login(email: email, password: password)
        callsAnApiBehindMe?.callApi(self)
        showHUD()
    }
    
    @IBAction func didTapRegisterButton(_ sender: Any) {
        self.navigate(to: .register)
    }
    
}

extension LoginViewController: LoginFeatureDelegate {
    
    func loginSuccess() {
        hideHUD()
        feature?.detach()
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginFailed(error: String) {
        hideHUD()
        loginButton.shake()
        showAlert(.error, message: error)
    }
    
}
