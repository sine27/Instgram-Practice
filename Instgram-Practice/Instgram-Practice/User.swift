//
//  User.swift
//  Instgram-Practice
//
//  Created by Shayin Feng on 3/20/17.
//  Copyright © 2017 Shayin Feng. All rights reserved.
//

import Foundation

class User {

    var id: String
    var email: String
    var username: String
    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        self.id = dictionary["_id"] as! String
        self.email = dictionary["email"] as! String
        self.username = dictionary["username"] as! String
    }
}
