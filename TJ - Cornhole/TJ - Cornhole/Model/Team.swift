//
//  Team.swift
//  TJ - Cornhole
//
//  Created by TJ on 8/8/17.
//  Copyright © 2017 TJ. All rights reserved.
//

import Foundation

/// Possible teams in a game
enum Team {
    case red
    case blue
    
    var name: String {
        switch self {
        case .red: return "Red"
        case .blue: return "Blue"
        }
    }
}

