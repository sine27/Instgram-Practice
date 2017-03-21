//
//  InstgramTableViewCell.swift
//  Instgram-Practice
//
//  Created by Shayin Feng on 3/19/17.
//  Copyright © 2017 Shayin Feng. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class InstgramTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var postImageView: PFImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var post: PFObject! {
        didSet {
            print(post)
            let user = post["author"] as? PFUser
            self.emailLabel.text = user?.username ?? "No Username"
            self.contentLabel.text = post["caption"] as? String ?? "No Content"
            self.postImageView.file = post["media"] as? PFFile
            self.postImageView.load { (image, error) in
                if let error = error {
                    print(error)
                }
                else if let image = image {
                    print("Success: Load")
                    self.postImageView.image = image
                }
                else {
                    print("???")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
        cardView.layer.borderWidth = 0.3
        cardView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        postImageView.image = nil
    }
    
}
