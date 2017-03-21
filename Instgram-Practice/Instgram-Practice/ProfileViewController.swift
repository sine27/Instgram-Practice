//
//  ProfileViewController.swift
//  Instgram-Practice
//
//  Created by Shayin Feng on 3/19/17.
//  Copyright © 2017 Shayin Feng. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var profileTable: UITableView!
    
    var posts: [PFObject] = []
    
    var user: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            print("Other User")
            user = PFUser.current()
            fetchImage()
        }
        print(user?.username)
        if let username = user?.username {
            userLabel.text = username
        } else {
            userLabel.text = "Unkown User"
        }

        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        avatarImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        avatarImageView.layer.shadowOpacity = 0.8
        
        profileTable.estimatedRowHeight = 100
        profileTable.rowHeight = UITableViewAutomaticDimension
        profileTable.register(UINib(nibName: "InstgramTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func fetchImage() {
        if let user = user {
            
            // let predicate = NSPredicate(format: "author.objectId = '\(userid)'")
            let query = PFQuery(className: "Post")
            query.order(byDescending: "createdAt")
            query.includeKey("author")
            query.limit = 20
            
            // fetch data asynchronously
            query.findObjectsInBackground { (results, error) in
                if let results = results {
                    for result in results {
                        if let author = result["author"] as? PFUser {
                            if author.objectId == self.user?.objectId {
                                self.posts.append(result)
                            }
                        }
                    }
                    print("Success: \(self.posts)")
                    self.profileTable.reloadData()
                } else {
                    UIHelper.alertMessage("Fetch Post", userMessage: "Error: \(error?.localizedDescription)", action: nil, sender: self)
                }
            }
        }
    }
    
    @IBAction func refreshbutoonTapped(_ sender: Any) {
        fetchImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func settingButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { (action) in
            
            UIHelper.alertMessageWithAction("Log Out", userMessage: "Are you sure to logout?", left: "Cancel", right: "Logout", leftAction: nil, rightAction: { (action) in
                PFUser.logOutInBackground(block: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Logged out")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                })
            }, sender: self)
            
        }
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InstgramTableViewCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}
