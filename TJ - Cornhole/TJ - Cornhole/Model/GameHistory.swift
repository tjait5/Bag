//
//  GameHistory.swift
//  TJ - Cornhole
//
//  Created by TJ on 2/9/18.
//  Copyright © 2018 TJ. All rights reserved.
//

import Foundation
import UIKit

class GameHistory: NSObject, NSCoding{
    
    struct Keys{
        static let date = "date"
        static let gameScorer = "gameScorerObj"
    }
 
    var date = Date()
    var gameScorer = GameScorer()
    
    //MARK:Init
    init(gameScorer: GameScorer) {
        self.gameScorer = gameScorer
    }
    
    //MARK::NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.date, forKey: Keys.date)
        aCoder.encode(self.gameScorer, forKey: Keys.gameScorer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let dateObject = aDecoder.decodeObject(forKey: Keys.date) as? Date{
            self.date = dateObject
        }
        if let gameScorerObject = aDecoder.decodeObject(forKey: Keys.gameScorer) as? GameScorer{
            self.gameScorer = gameScorerObject
        }
        super.init()
    }
}
