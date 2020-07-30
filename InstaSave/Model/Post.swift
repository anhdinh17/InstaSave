//
//  Post.swift
//  InstaSave
//
//  Created by Anh Dinh on 7/16/20.
//  Copyright © 2020 Anh Dinh. All rights reserved.
//

import UIKit

final class Post {
    
    let user: User
    
    let imageUrl: URL
    
    let videoUrl: URL?
    
    var image: UIImage?
    
    var isVideo: Bool {
        return videoUrl != nil // return true if videoUrl is not nil
    }

    init(user: User, imageUrl: URL, videoUrl: URL?) {
        self.user = user
        self.imageUrl = imageUrl
        self.videoUrl = videoUrl
    }
}
