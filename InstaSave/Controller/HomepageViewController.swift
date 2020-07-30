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
    
    //    var imageUrl = URL()
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
    
    //MARK: - Test Button
    @IBAction func pasteButton(_ sender: UIButton) {
        if let link = UIPasteboard.general.string { // link from clipboard
            checkLink(link)
        }
        
    }
    
    //    private func showMediaPost(_ post: Post) {
    //        let previewVC = post.isVideo
    //        present(previewVC, animated: true)
    //    }
    
    //MARK: - Save Photos
    @IBAction func saveButtonPressed(_ sender: UIButton) {
           UIImageWriteToSavedPhotosAlbum(imageFromData, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
  
    private func checkLink(_ link: String) {
        guard let activeLink = InstaService.checkLink(link) else {
            showInvalidLinkMessage()
            return
        }
        
        //  changeButtonTitle()
        InstaService.getMediaPost(with: activeLink) { post in
            //self.setInitialButtonTitle()
            guard let post = post else {
                self.showConnectionErrorMessage()
                return
            }
            
            self.imageFromData = post.image!
            print("Image from post.image: \(self.imageFromData)")
            print(post.imageUrl)
            
            self.urlToString = post.imageUrl.absoluteString
            
            print("String of the url: \(self.urlToString)")
            
            self.setImage(from: self.urlToString)
            
            //self.showMediaPost(post)
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
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            self.imageFromData = image! // thêm vào để lấy UIImage
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


/*
 // FUNC TO NETWORKING imageUrl
 func imageURL (){
 // get image from imageURL
 let catPictureURL = URL(string: "https://image.blockbusterbd.net/00416_main_image_04072019225805.png")!
 
 // Creating a session object with the default configuration.
 // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
 let session = URLSession(configuration: .default)
 
 // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
 let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
 // The download has finished.
 if let e = error {
 print("Error downloading cat picture: \(e)")
 } else {
 // No errors found.
 // It would be weird if we didn't have a response, so check for that too.
 if let res = response as? HTTPURLResponse {
 print("Downloaded cat picture with response code \(res.statusCode)")
 if let imageData = data {
 // Finally convert that Data into an image and do what you wish with it.
 DispatchQueue.main.async {
 self.imageFromDataURL = UIImage(data: imageData,scale: 2.0)!
 print("This is image from URL: \(self.imageFromDataURL)")
 }
 
 // Do something with your image.
 } else {
 print("Couldn't get image: Image is nil")
 }
 } else {
 print("Couldn't get response code for some reason")
 }
 }
 }
 downloadPicTask.resume()
 }
 */
