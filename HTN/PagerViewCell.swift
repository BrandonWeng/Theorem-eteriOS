//
//  PagerViewCell.swift
//  HTN
//
//  Created by Ziyin Wang on 2017-09-16.
//  Copyright © 2017 ziyincody. All rights reserved.
//

import UIKit
import FSPagerView

class PagerViewCell: UICollectionViewCell {

    let imageView:UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
