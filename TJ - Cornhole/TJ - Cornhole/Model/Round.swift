//
//  Round.swift
//  TJ - Cornhole
//
//  Created by TJ on 2/8/17.
//  Copyright © 2017 TJ. All rights reserved.
//

import Foundation

/// Represents a round in a cornhole game. A round is over when both teams
/// have made 4 throws.
class Round: NSObject, NSCoding {
    
    struct Keys{
        static let redThrows = "redThrows"
        static let blueThrows = "blueThrows"
        static let startingTeam = "startingTeam"
    }
    
    var startingTeam: Team = .red
    var redThrows = [Throw]()
    var blueThrows = [Throw]()
    
    var isNew: Bool {
        return redThrows.isEmpty && blueThrows.isEmpty
    }
    
    //MARK::Init
    init(startingTeam: Team) {
        self.startingTeam = startingTeam
    }
    
    //MARK::NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(redThrows, forKey: Keys.redThrows)
        aCoder.encode(blueThrows, forKey: Keys.blueThrows)
        aCoder.encode(startingTeam.name, forKey: Keys.startingTeam)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let redThrowsObject = aDecoder.decodeObject(forKey: Keys.redThrows) as? [Throw]{
            self.redThrows = redThrowsObject
        }
        if let blueThrowsObject = aDecoder.decodeObject(forKey: Keys.blueThrows) as? [Throw]{
            self.blueThrows = blueThrowsObject
        }
        if let startingTeamObject = aDecoder.decodeObject(forKey: Keys.startingTeam) as? Team{
            self.startingTeam = startingTeamObject
        }
        super.init()
    }
    
    //MARK::Public
    func getThrowsForTeam(team:  Team) -> [Throw] {
        switch(team){
        case .red:
            return redThrows
        case .blue:
            return blueThrows
        }
    }
    
    func setThrowsForTeam(team: Team ,throwArray: [Throw]){
        switch(team){
        case .red:
            redThrows = throwArray
        case .blue:
            blueThrows = throwArray
        }
    }
    
}

