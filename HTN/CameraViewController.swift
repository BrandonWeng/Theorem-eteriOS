//
//  CameraViewController.swift
//  HTN
//
//  Created by Ziyin Wang on 2017-09-15.
//  Copyright © 2017 ziyincody. All rights reserved.
//

import UIKit
import Alamofire
import TOCropViewController
import AFNetworking
import NVActivityIndicatorView

class KeywordObj: NSObject {
    
    var name:String = ""
    var fileNames:[String] = []
    
    init(wordName:String, thisfileNames:String) {
        name = wordName
        let array = thisfileNames.components(separatedBy: ",")
        for filename in array{
            fileNames.append(filename)
        }
    }
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate, NVActivityIndicatorViewable {

    var keywords:[KeywordObj] = []
    var suggested:KeywordObj = KeywordObj(wordName: "", thisfileNames: "")
    
    var imagePicker:UIImagePickerController!
    
    let imageView:UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let tapLabel:UILabel = {
        let lb = UILabel()
        lb.text = "Forgot theorems?\nTap to start"
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.textColor = UIColor.gray
        lb.font = UIFont.systemFont(ofSize: 30)
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .default
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(takePhoto(sender:))))
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.purple
        setupViews()
    }
    
    func setupViews(){
        view.addSubview(imageView)
        view.addSubview(tapLabel)
        
        tapLabel.translatesAutoresizingMaskIntoConstraints = false
        tapLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tapLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func takePhoto(sender:UITapGestureRecognizer)
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.showsCameraControls = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let cropViewController = TOCropViewController(image: info[UIImagePickerControllerOriginalImage] as! UIImage)
        cropViewController.delegate = self
        
        self.imagePicker.present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)!
        
        let manager = AFHTTPSessionManager()
        cropViewController.dismiss(animated: true, completion: nil)
        self.imagePicker.dismiss(animated: true) { 
            self.startAnimating(CGSize(width:100, height:100) , message: "Scanning...", messageFont: UIFont.systemFont(ofSize: 22), type: .pacman, color: UIColor.black, padding: 0, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: UIColor.black)
        }

        manager.post("https://c246944c.ngrok.io/upload_image", parameters: nil, constructingBodyWith: { (data) in
                data.appendPart(withFileData: imageData, name: "file",fileName: "hello.jpeg", mimeType: "image/jpeg")
        }, progress: nil, success: { (operation, responseObject) in
            print("SUCCESS")
            
            do {
                if let dictionary = responseObject as? [String:Any] {
                    let result = dictionary["result"] as? [String:String]
                    
                    for (key,value) in result! {
                        print(key)
                        print(value)
                        if (key == "suggested")
                        {
                            self.suggested = KeywordObj(wordName: "Suggested Theorems", thisfileNames: value)
                        }
                        else
                        {
                            self.keywords.append(KeywordObj(wordName: key, thisfileNames: value))
                        }
                    }
                }
            }catch {
                print("ERROR")
            }
            
            DispatchQueue.main.async {
                self.stopAnimating()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTableViewController") as! KeywordsTableController
                vc.keywords = self.keywords
                vc.suggested = self.suggested
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }) { (operation, error) in
            print(error.localizedDescription)
            DispatchQueue.main.async {
                self.stopAnimating()
            }
        }
    }
}
