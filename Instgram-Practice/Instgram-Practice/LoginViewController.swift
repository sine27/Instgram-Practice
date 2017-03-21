//
//  LoginViewController.swift
//  Instgram-Practice
//
//  Created by Shayin Feng on 3/19/17.
//  Copyright © 2017 Shayin Feng. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var signinLabel: UILabel!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var toolbarToBottom: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var tapGesture = UITapGestureRecognizer()
    
    var isLoginView = true
    
    let signinText = "Sign in"
    let signupText = "Sign up"
    let segueIdentifier = "loggedIn"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signupButton.layer.cornerRadius = 5
        nextButton.layer.cornerRadius = 5
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.6, animations: {
                self.view.layoutIfNeeded()
                self.toolbarToBottom.constant = keyboardSize.height
            })
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            UIView.animate(withDuration: 0.6, animations: {
                self.view.layoutIfNeeded()
                self.toolbarToBottom.constant = 0
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        isLoginView = !isLoginView
        if isLoginView {
            signinLabel.text = signinText
            signupButton.setTitle(signupText, for: .normal)
            nextButton.setTitle(signinText, for: .normal)
        } else {
            signinLabel.text = signupText
            signupButton.setTitle(signinText, for: .normal)
            nextButton.setTitle(signupText, for: .normal)
        }
    }

    @IBAction func nextStep(_ sender: UIButton) {
        
        let username = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if username == "" {
            UIHelper.alertMessage("Failed", userMessage: "Please Enter the Username", action: nil, sender: self)
        }
        if password == "" {
            UIHelper.alertMessage("Failed", userMessage: "Please Enter the Password", action: nil, sender: self)
        }
        
        if isLoginView {
            
            PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
                if let error = error {
                    print(error)
                    UIHelper.alertMessage("Sign In", userMessage: "\nError: \(error.localizedDescription)", action: nil, sender: self)
                } else {
                    print("User logged in successfully")
                    UIHelper.alertMessage("Sign Up", userMessage: "Welcome back \(user?.username ?? "")!", action: { (action) in
                        self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
                    }, sender: self)
                }
            })
        } else {
            // initialize a user object
            let newUser = PFUser()
            
            // set user properties
            newUser.username = username
            newUser.email = username
            newUser.password = password
            
            // call sign up function on the object
            newUser.signUpInBackground { (success, error) in
                if let error = error {
                    print(error)
                    UIHelper.alertMessage("Sign Up", userMessage: "\nError: \(error.localizedDescription)", action: nil, sender: self)
                } else {
                    // manually segue to logged in view
                    UIHelper.alertMessage("Sign Up", userMessage: "Welcome!", action: { (action) in
                        self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
                    }, sender: self)
                }
            }
        }
    }
    
    @IBAction func forgotPasswordTapped(_ sender: UIBarButtonItem) {
        UIHelper.alertMessage("Forgot Password", userMessage: "Not implemented...", action: nil, sender: self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    // Mark : Text Filed position
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
}
