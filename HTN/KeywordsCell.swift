//
//  KeywordsCell.swift
//  HTN
//
//  Created by Ziyin Wang on 2017-09-16.
//  Copyright © 2017 ziyincody. All rights reserved.
//

import UIKit
import FoldingCell
import EasyPeasy

class KeywordsCell: UITableViewCell {
    @IBOutlet weak var wordNumber: UILabel!

    @IBOutlet weak var foregroundView: UIView!
    @IBOutlet weak var keyword: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
    }
}
