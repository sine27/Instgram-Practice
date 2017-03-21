//
//  PostViewController.swift
//  Instgram-Practice
//
//  Created by Shayin Feng on 3/19/17.
//  Copyright © 2017 Shayin Feng. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postTextField: UITextField!
    
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    var tap = UITapGestureRecognizer()
    
    let helper = UIHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        
        view.endEditing(true)
        
        if postImageView.image == nil {
            UIHelper.alertMessage("Post", userMessage: "Please choose an image.", action: nil, sender: self)
        } else if postTextField.text == nil || postTextField.text == "" {
            UIHelper.alertMessage("Post", userMessage: "Please fill the text field.", action: nil, sender: self)
        } else {
            postButton.isEnabled = false
            DispatchQueue.global(qos: .userInitiated).async {
                
                let text = self.postTextField.text
                Post.postUserImage(image: self.postImageView.image, withCaption: text, withCompletion: { (success, error) in
                    self.helper.stopActivityIndicator()
                    self.postButton.isEnabled = true
                    if success {
                        print("post success")
                        self.postImageView.image = nil
                        self.postTextField.text = ""
                        self.tabBarController?.selectedIndex = 0
                    } else {
                        print(error?.localizedDescription ?? "")
                        UIHelper.alertMessage("Post", userMessage: "Error: \(error?.localizedDescription ?? "Unkown Error")", action: nil, sender: self)
                    }
                })
                
                DispatchQueue.main.async {
                    self.helper.activityIndicator(sender: self, style: .whiteLarge)
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    @IBAction func chooseAnImage(_ sender: UIButton) {
        print("Tapped")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.camera
            
            self.present(vc, animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            self.present(vc, animated: true, completion: nil)
        }
        alertController.addAction(libraryAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        // let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        postImageView.image = editedImage
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
}
