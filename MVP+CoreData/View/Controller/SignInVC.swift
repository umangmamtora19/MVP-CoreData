//
//  ViewController.swift
//  MVP+CoreData
//
//  Created by Umang on 16/06/23.
//

import UIKit
import Toast

class SignInVC: UIViewController {

//    MARK: - Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblDontHaveAc: UILabel!
    
//    MARK: - Variables
    let presenter: AuthPresenter = AuthPresenter()
    
//    MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(delegate: self)
        setupUI()
    }
}

//    MARK: - Common functions
extension SignInVC {
    func setupUI() {
        btnSignIn.setCorners(ofRadius: 4)
    }
    
    func moveToDashboard() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

//      MARK: - Actions
extension SignInVC {
    @IBAction func btnSignInAction(_ sender: UIButton) {
        if txtEmail.text == "" {
            self.showToast("Please enter email")
        } else if !txtEmail.text!.isValidEmail {
            self.showToast("Please enter valida email")
        } else if txtPassword.text == "" {
            self.showToast("Please enter password")
        } else if txtPassword.text!.count < 6 {
            self.showToast("Please enater password with more than 6 characters")
        } else {
            if btnSignIn.isSelected {
                if txtPassword.text != txtConfirmPassword.text {
                    self.showToast("Confirm password does not match please enter valid confirm password")
                } else {
                    let params: [String: Any] = [
                        "email": txtEmail.text ?? "",
                        "password": txtPassword.text ?? ""
                    ]
                    presenter.signupWith(params: params)
                }
            } else {
                let params: [String: Any] = [
                    "email": txtEmail.text ?? "",
                    "password": txtPassword.text ?? ""
                ]
                presenter.signinWith(params: params)

            }
        }
    }
    
    @IBAction func btnSignUpActions(_ sender: UIButton) {
        btnSignIn.isSelected.toggle()
        btnSignUp.isSelected.toggle()
        
        UIView.animate(withDuration: 0.2) { [self] in
            if btnSignIn.isSelected {
                lblHeader.text = "Sign Up"
                lblDontHaveAc.text = "Don't have account?"
                lblWelcome.isHidden = true
                txtConfirmPassword.isHidden = false
            } else {
                lblHeader.text = "Sign In"
                lblDontHaveAc.text = "Have an account?"
                lblWelcome.isHidden = false
                txtConfirmPassword.isHidden = true
            }
        }
    }
}

//      MARK: - AuthPresenterDelegate Methods
extension SignInVC: AuthPresenterDelegate {
    func signin(success: Bool, message: String) {
        DispatchQueue.main.async {
            if success {
                self.moveToDashboard()
            } else {
                self.showToast(message)
            }
        }
    }
    
    func signup(success: Bool, message: String) {
        DispatchQueue.main.async {
            if success {
                self.moveToDashboard()
            } else {
                self.showToast(message)
            }
        }
    }
}
