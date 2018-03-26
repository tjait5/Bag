//
//  OptionsCell.swift
//  TJ - Cornhole
//
//  Created by TJ on 2/2/18.
//  Copyright © 2018 TJ. All rights reserved.
//

import Foundation
import UIKit

class OptionsCell: UITableViewCell{
    
    var mainLabel = UILabel()
    
    //MARK::Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if(reuseIdentifier == "MenuOptionsCell"){
            self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        self.contentView.addSubview(mainLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainLabel.frame = CGRect(x: 15, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
    }
}
