//
//  GameHistoryCell.swift
//  TJ - Cornhole
//
//  Created by TJ on 2/9/18.
//  Copyright © 2018 TJ. All rights reserved.
//

import Foundation
import UIKit

class GameHistoryCell: UITableViewCell{
    
    var gameScorer = GameScorer()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var blueTeamLabel: UILabel!
    @IBOutlet weak var redTeamLabel: UILabel!
    @IBOutlet weak var blueScoreLabel: UILabel!
    @IBOutlet weak var redScoreLabel: UILabel!
    @IBOutlet weak var blueWinIndicator: UIImageView!
    @IBOutlet weak var redWinIndicator: UIImageView!
    
    //MARK::Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK::Public    
    func setGameScorer(gameScorer: GameScorer){
        self.gameScorer = gameScorer
        self.configureView()
    }
    
    func configureView(){
        let winningTeam = self.gameScorer.gameWinner()
        self.blueScoreLabel?.text = "\(self.gameScorer.game.blueScore)"
        self.redScoreLabel?.text = "\(self.gameScorer.game.redScore)"
        
        //There can't possibly be a tie
        if(winningTeam == .red){
            self.redWinIndicator.isHidden = false
            self.redTeamLabel.font = UIFont.boldSystemFont(ofSize: self.redTeamLabel.font.pointSize)
        }
        else{
            self.blueWinIndicator.isHidden = false
            self.blueTeamLabel.font = UIFont.boldSystemFont(ofSize: self.blueTeamLabel.font.pointSize)
        }
    }
}
