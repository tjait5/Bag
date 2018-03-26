//
//  StatsViewController.swift
//  TJ-Cornhole
//
//  Created by Motus on 2/9/18.
//  Copyright © 2018 TJ. All rights reserved.
//

import Foundation
import UIKit

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let cellReuseIdendifier = "GameHistoryCell"
    let dateFormatter = DateFormatter()
    var gameHistory: [GameHistory]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var redWinsLabel: UILabel!
    @IBOutlet weak var blueWinsLabel: UILabel!
    @IBOutlet weak var avgTossesLabel: UILabel!
    @IBOutlet weak var noHistoryLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    //MARK::Init
    required init?(coder aDecoder: NSCoder) {
        if let gameHistoryData = UserDefaults.standard.object(forKey: "gameHistory") as? Data{
            self.gameHistory = NSKeyedUnarchiver.unarchiveObject(with: gameHistoryData) as! [GameHistory]
        }
        else{
            self.gameHistory = [GameHistory]()
        }
        self.gameHistory.reverse()  //So most recently completed games at top.  Could also insert games at index 0 to avoid expensive sort
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "EEE, MMMM d"
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.gameHistory.count > 0){
            self.configureView()
            tableView.reloadData()
        }
        else{
            self.configureNoGameHistoryView()
        }
    }
    
    //MARK::Public
    func configureView(){
        
        //Calculate statistics based on GameHistoryArray and update UI
        self.tableView.isHidden = false
        self.noHistoryLabel.isHidden = true
        self.redWinsLabel?.text = "\(self.getNumberOfWinsForTeam(team: .red))"
        self.blueWinsLabel?.text = "\(self.getNumberOfWinsForTeam(team: .blue))"
        self.avgTossesLabel?.text = "\(self.getAvgTossesPerGame())"
        
    }
    
    func configureNoGameHistoryView(){
        self.tableView.isHidden = true
        self.noHistoryLabel.isHidden = false
    }
    
    func getNumberOfWinsForTeam(team: Team) -> Int{
        var totalWins = 0
        for i in 0..<self.gameHistory.count{
            let indexGameScorer = self.gameHistory[i].gameScorer
            if(indexGameScorer.gameWinner() == team){
                totalWins += 1
            }
        }
        return totalWins
    }
    
    func getAvgTossesPerGame() -> Int{
        var totalThrowsForHistory = 0
        var avgThrowsPerGame = 0
        if(self.gameHistory.count > 0){
            for i in 0..<self.gameHistory.count{
                let indexGameScorer = self.gameHistory[i].gameScorer
                totalThrowsForHistory += indexGameScorer.game.getTotalThrowsForGame()
            }
            avgThrowsPerGame = Int(totalThrowsForHistory / self.gameHistory.count)
        }
        return avgThrowsPerGame
    }
    
    //MARK::TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath) as! GameHistoryCell
        let indexGameHistory = self.gameHistory[indexPath.row]
        cell.dateLabel?.text = self.dateFormatter.string(from: indexGameHistory.date)
        cell.setGameScorer(gameScorer: indexGameHistory.gameScorer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 3.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    //MARK::Actions
    @IBAction func startNewGamePressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScoringViewController")
        self.present(vc, animated: true, completion: nil)
    }
}
