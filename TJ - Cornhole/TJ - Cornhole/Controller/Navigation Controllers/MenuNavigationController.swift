//
//  MenuNavigationController.swift
//  TJ - Cornhole
//
//  Created by TJ on 2/2/18.
//  Copyright © 2018 TJ. All rights reserved.
//

import Foundation
import UIKit

class MenuNavigationController: UINavigationController{
    
    var gameScorer = GameScorer()
    
    // MARK::Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
