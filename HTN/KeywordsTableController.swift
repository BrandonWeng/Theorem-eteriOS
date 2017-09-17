//
//  KeywordsTableController.swift
//  HTN
//
//  Created by Ziyin Wang on 2017-09-16.
//  Copyright © 2017 ziyincody. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire
import NVActivityIndicatorView

class KeywordsTableController: UITableViewController, NVActivityIndicatorViewable {

    let kCloseCellHeight: CGFloat = 250
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    
    var keywords:[KeywordObj] = []
    
    var suggested:KeywordObj = KeywordObj(wordName: "Suggested Theorems \n", thisfileNames: "")
    
    let backButton:UIButton = {
        let bt = UIButton()
        bt.setTitle("Back", for: .normal)
        bt.backgroundColor = UIColor.clear
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        return bt
    }()
    
    let titleLabel:UILabel = {
        let lb = UILabel()
        lb.text = "Keywords"
        lb.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightThin)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor.black
        lb.textAlignment = .center
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        cellHeights = Array(repeating: kCloseCellHeight, count: 10)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.white
        
        NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple, color: UIColor.purple, padding: 0)
    }
    
    func back(sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as KeywordsCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        let initialScale: CGFloat = 1.2
        let duration: TimeInterval = 0.5
        
        cell.alpha = 0.0
        cell.layer.transform = CATransform3DMakeScale(initialScale, initialScale, 1)
        UIView.animate(withDuration: duration, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath) as! KeywordsCell
        
        if (indexPath.row == 0)
        {
            cell.keyword.text = suggested.name
        }
        else
        {
            cell.keyword.text = keywords[indexPath.row - 1].name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = ["image/png"]
        
        let vc = PagerViewController()
        
        var fileNames:[String] = []
        var keywordName:String = ""
        
        if (indexPath.row == 0)
        {
            fileNames = suggested.fileNames
            keywordName = suggested.name
        }
        else
        {
            fileNames = keywords[indexPath.row - 1].fileNames
            keywordName = keywords[indexPath.row - 1].name
        }
        
        let group = DispatchGroup()
        
        self.startAnimating(CGSize(width:100, height:100) , message: "Downloading", messageFont: UIFont.systemFont(ofSize: 22), type: .ballClipRotateMultiple, color: UIColor.black, padding: 0, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: UIColor.black)

        for name in fileNames {
            group.enter()
            
            Alamofire.request("https://c246944c.ngrok.io/get/picture/\(name).jpg").response(completionHandler: { (data) in
                    print("here")
                    group.leave()
                    print("https://c246944c.ngrok.io/get/picture/\(name).jpg")
                    vc.images.append(UIImage(data: data.data!)!)
                    vc.keyword.text = keywordName
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.stopAnimating()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

