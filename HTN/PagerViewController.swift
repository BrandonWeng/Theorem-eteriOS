//
//  PagerViewController.swift
//  HTN
//
//  Created by Ziyin Wang on 2017-09-16.
//  Copyright © 2017 ziyincody. All rights reserved.
//

import UIKit
import FSPagerView

class PagerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var images: [UIImage] = []
    
    let backButton:UIButton = {
        let bt = UIButton()
        bt.setTitle("Back", for: .normal)
        bt.backgroundColor = UIColor.clear
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        return bt
    }()
    
    let keyword:UILabel = {
        let lb = UILabel()
        lb.text = "Keyword"
        lb.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightThin)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor.black
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var pgView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let pg = UICollectionView(frame: .zero, collectionViewLayout: layout)
        pg.delegate = self
        pg.dataSource = self
        pg.backgroundColor = UIColor.clear
        pg.isPagingEnabled = true
        return pg
    }()
    
    func back(sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradianteLayer = CAGradientLayer()
        gradianteLayer.frame = view.bounds
        gradianteLayer.colors = [UIColor(red: 252/255.0, green: 227/255.0, blue: 138/255.0, alpha: 1.0).cgColor, UIColor(red: 243/255.0, green: 129/255.0, blue: 129/255.0, alpha: 1.0).cgColor]
        view.layer.addSublayer(gradianteLayer)
        
        view.addSubview(pgView)

        pgView.translatesAutoresizingMaskIntoConstraints = false
        pgView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pgView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pgView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pgView.register(PagerViewCell.self, forCellWithReuseIdentifier: "pagerView")
        images.append(UIImage(named: "theoremBody1")!)
        images.append(UIImage(named: "theoremBody2")!)
        images.append(UIImage(named: "theoremBody3")!)
        
        view.addSubview(keyword)
        
        keyword.bottomAnchor.constraint(equalTo: pgView.topAnchor, constant:-20).isActive = true
        keyword.centerXAnchor.constraint(equalTo: pgView.centerXAnchor).isActive = true
        keyword.widthAnchor.constraint(equalTo:pgView.widthAnchor).isActive = true
        keyword.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let ratio:CGFloat = images[indexPath.item].size.height / images[indexPath.item].size.width
        return CGSize(width: self.view.frame.width, height: min(collectionView.frame.size.height, self.view.frame.width * ratio))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        pgView.heightAnchor.constraint(equalToConstant: self.view.frame.width / 2.3).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 26).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let initialScale: CGFloat = 1.2
        let duration: TimeInterval = 0.3
        
        cell.alpha = 0.0
        cell.layer.transform = CATransform3DMakeScale(initialScale, initialScale, 1)
        UIView.animate(withDuration: duration, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pagerView", for: indexPath) as! PagerViewCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
}
