//
//  ViewController.swift
//  InstaSave
//
//  Created by Anh Dinh on 7/9/20.
//  Copyright © 2020 Anh Dinh. All rights reserved.
//

import UIKit

class HomepageViewController:UIViewController{
    
    @IBOutlet weak var pasteButtonOutlet: UIButton!
    @IBOutlet weak var instagramButtonOutlet: UIButton!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    
    var urlToString: String = ""
    
    var imageFromData = UIImage()
    var imageFromDataURL = UIImage()
    
    var pasteboard = UIPasteboard.general
    
    @IBOutlet weak var photoFromLink: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pasteButtonOutlet.layer.cornerRadius = 9
        instagramButtonOutlet.layer.cornerRadius = 9
        instagramButtonOutlet.titleLabel?.font = UIFont(name: "SnellRoundhand-Bold", size: 30)
        pasteButtonOutlet.titleLabel?.font = UIFont(name: "SnellRoundhand-Bold", size: 30)
        saveButtonOutlet.titleLabel?.font = UIFont(name: "SnellRoundhand-Bold", size: 30)
    }
    //MARK: - Insta Button
    @IBAction func instaButton(_ sender: UIButton) {
        let instagramUrl = URL(string: "instagram://app")!
               let websiteUrl = URL(string: "https://apple.com")!
               
               // check if instagram app is installed on the device
               if UIApplication.shared.canOpenURL(instagramUrl){
                   UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
               } else { // go to website if we can't open instagram app
                   UIApplication.shared.open(websiteUrl)
               }
    }
    
    //MARK: - Paste Button
    @IBAction func pasteButton(_ sender: UIButton) {
        if let link = UIPasteboard.general.string { // link from clipboard
            checkLink(link)
        }
        
    }

    //MARK: - Save Photos
    @IBAction func saveButtonPressed(_ sender: UIButton) {
           UIImageWriteToSavedPhotosAlbum(imageFromData, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
  
    private func checkLink(_ link: String) {
        guard let activeLink = InstaService.checkLink(link) else {
            showInvalidLinkMessage()
            return
        }
        
       // get data from link
        InstaService.getMediaPost(with: activeLink) { post in
            
            // post is an object of Post
            guard let post = post else {
                self.showConnectionErrorMessage()
                return
            }
            
            // imageFromData is UIImage
            self.imageFromData = post.image!
            print("Image from post.image: \(self.imageFromData)")
            print(post.imageUrl) // imageURL is the URL of the image, it's from Post
            
            self.urlToString = post.imageUrl.absoluteString
            
            print("String of the url: \(self.urlToString)")
            
            self.setImage(from: self.urlToString)
            
            
        }
    }
    
    private func showConnectionErrorMessage() {
        //Alert.showMessage("Connection Error")
        let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showInvalidLinkMessage() {
        //Alert.showMessage("Invalid Link")
        let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - setImage Function
    // this func is to networking the image we need and set the image on screen
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            self.imageFromData = image! // put in here to get UIImage
            DispatchQueue.main.async {
                self.photoFromLink.image = image
            }
        }
    }
    
    //MARK: - Func to save image to Photo Library
    // What happens if we can/can't save the photos to Photo Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
}



