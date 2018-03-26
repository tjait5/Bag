//
//  Game.swift
//  TJ - Cornhole
//
//  Created by TJ on 2/8/17.
//  Copyright © 2017 TJ. All rights reserved.
//

import Foundation

/// Represents a single game of cornhole.
class Game: NSObject, NSCoding {
    
    struct Keys{
        static let rounds = "rounds"
        static let hasSetScoreForRound = "hasSetScoreForRound"
        static let redScore = "redScore"
        static let blueScore = "blueScore"
    }
    
    var rounds = [Round]()
    var hasSetScoreForRound = false
    var redScore = 0
    var blueScore = 0
    
    var currentRoundNumber: Int {
        return self.rounds.count
    }
    
    var currentRound: Round {
        return self.rounds.last!
    }
    
    //MARK:Init
    init(startingTeam: Team = .red) {
        self.rounds = [Round(startingTeam: startingTeam)]
    }
    
    //MARK::NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.rounds, forKey: Keys.rounds)
        aCoder.encode(self.hasSetScoreForRound, forKey: Keys.hasSetScoreForRound)
        aCoder.encode(self.redScore, forKey: Keys.redScore)
        aCoder.encode(self.blueScore, forKey: Keys.blueScore)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let roundsObject = aDecoder.decodeObject(forKey: Keys.rounds) as? [Round]{
            self.rounds = roundsObject
        }
        self.hasSetScoreForRound = aDecoder.decodeBool(forKey: Keys.hasSetScoreForRound)
        self.redScore = aDecoder.decodeInteger(forKey: Keys.redScore)
        self.blueScore = aDecoder.decodeInteger(forKey: Keys.blueScore)
        super.init()
    }
    
    //MARK::Public
    func setHasSetScoreForRound(lock: Bool){
        self.hasSetScoreForRound = lock
    }
    
    func setRedScore(score: Int){
        self.redScore = score
    }
    
    func setBlueScore(score: Int){
        self.blueScore = score
    }
    
    func setScore(redScore: Int, blueScore: Int){
        if(!hasSetScoreForRound){
            self.setHasSetScoreForRound(lock: true)
            if(redScore > blueScore){
                self.redScore += redScore - blueScore
            }
            else if(blueScore > redScore){
                self.blueScore += blueScore - redScore
            }
            else{
                //Nothing because scores are equal
            }
        }
    }
    
    func getTotalThrowsForGame() -> Int{
        var totalThrowsForGame = 0
        for indexRound in rounds{
            totalThrowsForGame += (indexRound.redThrows.count + indexRound.blueThrows.count)
        }
        return totalThrowsForGame
    }
}

