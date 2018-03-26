//
//  Throw.swift
//  TJ - Cornhole
//
//  Created by TJ on 2/8/17.
//  Copyright © 2017 TJ. All rights reserved.
//

import Foundation
import UIKit

/// Representes a single throw in a round, with one of the three possible results
///
/// - out: throw landed on the grass
/// - board: throw landed on the board
/// - hole: throw went in the hole

enum ThrowVal: Int {
    case out = 0
    case board = 1
    case hole = 3
    
    var points: Int {
        return self.rawValue
    }
}

class Throw: NSObject, NSCoding{
    
    var value: ThrowVal?
    var center: CGPoint!
    
    //MARK::Init
    init(value: ThrowVal, center: CGPoint) {
        self.value = value
        self.center = center
    }
    
    //MARK::NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value?.rawValue, forKey: "value")
        aCoder.encode(center, forKey: "center")
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let valueEnum = aDecoder.decodeObject(forKey: "value") as? Int{
            self.value = ThrowVal.init(rawValue: valueEnum)
        }
        if let centerPoint = aDecoder.decodeObject(forKey: "center") as? CGPoint{
            self.center = centerPoint
        }
        super.init()
    }
    
}


