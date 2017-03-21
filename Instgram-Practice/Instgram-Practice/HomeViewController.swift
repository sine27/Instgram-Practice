//
//  HomeViewController.swift
//  Instgram-Practice
//
//  Created by Shayin Feng on 3/19/17.
//  Copyright © 2017 Shayin Feng. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    
    var posts: [PFObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        refreshbutoonTapped(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.dataSource = self
        homeTableView.delegate = self
        homeTableView.estimatedRowHeight = 100
        homeTableView.rowHeight = UITableViewAutomaticDimension
        homeTableView.register(UINib(nibName: "InstgramTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        fetchImage()
    }
    
    func fetchImage() {
        
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (results, error) in
            if let results = results {
                self.posts = results
                print("Success")
                self.homeTableView.reloadData()
            } else {
                UIHelper.alertMessage("Fetch Post", userMessage: "Error: \(error?.localizedDescription)", action: nil, sender: self)
            }
        }
    }
    
    @IBAction func refreshbutoonTapped(_ sender: Any) {
        fetchImage()
        homeTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InstgramTableViewCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let vc = ProfileViewController()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        if let user = posts[indexPath.row]["author"] as? PFUser {
            print("test1")
            vc.user = user
            for post in posts {
                if let author = post["author"] as? PFUser {
                    print("test2")
                    if author.objectId == user.objectId {
                        vc.posts.append(post)
                    }
                }
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
