//
//  User.swift
//  InstaSave
//
//  Created by Anh Dinh on 7/16/20.
//  Copyright © 2020 Anh Dinh. All rights reserved.
//

import UIKit

final class User {
    
    let username: String
    
    let avatarUrl: URL
    
    var avatarImage: UIImage?
    
    init(username: String, avatarUrl: URL) {
        self.username = username
        self.avatarUrl = avatarUrl
    }
}
