//
//  Json.swift
//  InstaSave
//
//  Created by Anh Dinh on 7/16/20.
//  Copyright © 2020 Anh Dinh. All rights reserved.
//

import UIKit

typealias Json = [String : Any]

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1) {
        self.init(r: CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF), g: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF), b: CGFloat((Int(hex, radix: 16)!) & 0xFF), a: alpha)
    }
}

extension URLSession {
    
    class func getImage(url: URL, completion: @escaping (UIImage?) -> ()) {
        shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    completion(UIImage(data: data))
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }
}

extension String {
    
    var url: URL? {
        return URL(string: self)
    }
}

