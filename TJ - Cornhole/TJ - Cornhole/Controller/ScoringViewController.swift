//
//  ViewController.swift
//  TJ-Cornhole
//
//  Created by TJ on 2/8/17.
//  Copyright © 2017 TJ. All rights reserved.
//

import UIKit

class ScoringViewController: UIViewController, MenuDelegate{
    
    private static let redColor = UIColor(red: 0.75, green: 0.16, blue: 0.16, alpha: 1.00)
    private static let blueColor = UIColor(red:0.20, green:0.50, blue:0.81, alpha:1.00)
    
    private var gameScorer = GameScorer()
    private var bagViews = [BagView]()
    private var holePath = UIBezierPath()
    private var boardPath = UIBezierPath()
    private var canThrow = true
    private var isSimulating = false
    
    @IBOutlet weak var boardImageView: UIImageView!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var playView: UIView!
    
    @IBOutlet weak var redGameScoreLabel: UILabel!
    @IBOutlet weak var blueGameScoreLabel: UILabel!
    @IBOutlet weak var redRoundScoreLabel: UILabel!
    @IBOutlet weak var blueRoundScoreLabel: UILabel!
    
    @IBOutlet weak var redThrowIndicatorView: UIImageView!
    @IBOutlet weak var blueThrowIndicatorView: UIImageView!
    
    @IBOutlet weak var redBagCountContainerStackView: UIStackView!
    @IBOutlet weak var blueBagCountContainerStackView: UIStackView!
    
    // MARK::Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(regenerateAllThrowsInRound), name: .bagViewMoved, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshViews()
        self.redBagCountContainerStackView.arrangedSubviews.forEach({ self.configureBagCountIndicator($0, color: ScoringViewController.redColor) })
        self.blueBagCountContainerStackView.arrangedSubviews.forEach({ self.configureBagCountIndicator($0, color: ScoringViewController.blueColor) })
        self.boardImageView.layer.zPosition = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.gameScorer.isGameInProgress()){
            self.presentResumeGameAlert()
        }
        else{
            self.startNewGame()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.recalculatePaths()
    }
    
    // MARK::State Restoration
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(self.gameScorer, forKey: "gameScorer")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let gameScorerObject = coder.decodeObject(forKey: "gameScorer") as? GameScorer{
            self.gameScorer = gameScorerObject
        }
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        self.refreshViews()
        super.applicationFinishedRestoringState()
    }
    
    // MARK::Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Menu"){
            let menuNav = segue.destination as! MenuNavigationController
            let menuVC = menuNav.viewControllers.first as! MenuViewController
            menuVC.delegate = self
            menuNav.gameScorer = self.gameScorer
        }
    }
    
    // MARK::Public
    func startNewGame(){
        self.isSimulating = false
        self.clearBoard()
        self.gameScorer = GameScorer()
        self.refreshViews()
    }
    
    func startNewRound(){
        self.clearBoard()
        self.gameScorer.startNewRound()
        self.refreshViews()
    }
    
    func resumeGame(){
        self.clearBoard()
        self.refreshSubviewsForTeam(team: .red)
        self.refreshSubviewsForTeam(team: .blue)
    }
    
    // MARK::Private
    private func configureBagCountIndicator(_ countView: UIView, color: UIColor) {
        countView.layer.cornerRadius = 2
        countView.layer.borderWidth = 1
        countView.layer.borderColor = color.cgColor
    }
    
    private func handleTap(in point: CGPoint) {
        guard let nextTeam = self.gameScorer.nextTeamToThrow(),
            self.gameScorer.gameState == .roundInProgress else {
                return
        }
        
        let newBag = BagView(color: BagColor.color(for: nextTeam))
        self.playView.addSubview(newBag)
        newBag.center = point
        
        self.addThrowForBag(bag: newBag)
        self.bagViews.append(newBag)
        self.refreshViews()
    }
    
    private func addThrowForBag(bag: BagView) {
        let newThrow = self.newThrow(in: bag.center)
        self.gameScorer.addThrow(newThrow)
        
        if newThrow.value == .hole {
            bag.layer.zPosition = 1
        } else {
            bag.layer.zPosition = 3
        }
        
        switch self.gameScorer.gameState {
        case .roundOver:
            if(!isSimulating){
                self.presentRoundOverAlert()
            }
            else{
                self.startNewRound()
                self.simulatePressed(nil)
            }
        case .roundOverExceed:
            if(!isSimulating){
                self.presentRoundOverExceedAlert()
            }
            else{
                self.startNewRound()
                self.simulatePressed(nil)
            }
        case .gameOver:
            self.saveGameHistory()
            self.presentGameOverAlert()
        default:
            break
        }
    }
    
    private func newThrow(in point: CGPoint) -> Throw {
        if self.holePath.contains(point) {
            return Throw(value: ThrowVal.hole, center: point)
        } else if self.boardPath.contains(point) {
            return Throw(value: ThrowVal.board, center: point)
        } else {
            return Throw(value: ThrowVal.out, center: point)
        }
    }
    
    private func presentResumeGameAlert(){
        
        let startNewGame = UIAlertAction(title: "New Game", style: .default){ _ in
            self.startNewGame()
        }
        let resumeGame = UIAlertAction(title: "Resume", style: .default){ _ in
            self.resumeGame()
        }

        let title = "GC Baggo"
        let message = "You have a game in progress,\nwould you like to resume or start new game?"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(startNewGame)
        alertController.addAction(resumeGame)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentRoundOverAlert() {
        
        let startNextRoundAction = UIAlertAction(title: "Start Next Round", style: .default) { _ in
            self.clearBoard()
            self.gameScorer.startNewRound()
            self.refreshViews()
        }
        
        let title: String
        let message: String
        switch self.gameScorer.result(forRound: self.gameScorer.game.currentRound) {
        case .over(let winner, let points):
            if let winner = winner {
                title = "\(winner.name) Team wins round \(self.gameScorer.game.currentRoundNumber)!"
                message = "\(points) \(points == 1 ? "point" : "points") added to their total score"
            } else {
                title = "Round \(self.gameScorer.game.currentRoundNumber) is a tie!"
                message = "No point will be added to either team"
            }
            break
        case .inProgress:
            fatalError("Can't call presentRoundOverAlert when round is inProgress")
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(startNextRoundAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentRoundOverExceedAlert() {
        
        let startNextRoundAction = UIAlertAction(title: "Start Next Round", style: .default) { _ in
            self.startNewRound()
        }
        
        let title: String
        let message: String
        switch self.gameScorer.result(forRound: self.gameScorer.game.currentRound) {
        case .over(let winner, let points):
            if let winner = winner{
                title = "Oops!"
                message = "\(winner.name) Team went over 21 points.\n\(winner.name) Team's score will be reset to 11"
            }
            else{
                title = "Oops! Score exceeds 21 points"
                message = "Score will be reset to 11"
            }
            break
        case .inProgress:
            fatalError("Can't call presentRoundOverAlert when round is inProgress")
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(startNextRoundAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentGameOverAlert() {
        
        guard let winner = self.gameScorer.winner else {
            fatalError("There must be a winner before attempting to present the game over alert")
        }
        
        let startNewGameAction = UIAlertAction(title: "Start New Game", style: .default) { _ in
            self.startNewGame()
        }
        
        let title = "\(winner.name) Team Wins!"
        let message = "Final score:\n" +
            "\(Team.red.name) Team: \(self.gameScorer.game.redScore), " +
            "\(Team.blue.name) Team: \(self.gameScorer.game.blueScore)"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(startNewGameAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func clearBoard() {
        self.bagViews.forEach({ $0.removeFromSuperview() })
        self.bagViews.removeAll()
    }
    
    // For simplicity when users drag and drop a bag we regenerate all the throws in the round
    @objc private func regenerateAllThrowsInRound() {
        self.gameScorer.clearCurrentRound()
        self.bagViews.forEach({ self.addThrowForBag(bag: $0) })
        self.refreshViews()
    }
    
    //Using the throws from the currentRound, replace all subviews on playboard
    private func refreshSubviewsForTeam(team: Team){
        let currentRound = self.gameScorer.game.currentRound
        let currentRoundThrows = currentRound.getThrowsForTeam(team: team)
        
        for roundThrow in currentRoundThrows{
            let newBag = BagView(color: BagColor.color(for: team))
            self.playView.addSubview(newBag)
            newBag.center = roundThrow.center
            
            if roundThrow.value == .hole {
                newBag.layer.zPosition = 1
            } else {
                newBag.layer.zPosition = 3
            }
            
            self.bagViews.append(newBag)
        }
    }
    
    private func refreshViews() {
        self.roundLabel.text = "Round \(self.gameScorer.game.currentRoundNumber)"
        self.redGameScoreLabel.text = "\(self.gameScorer.game.redScore)"
        self.blueGameScoreLabel.text = "\(self.gameScorer.game.blueScore)"
        self.redRoundScoreLabel.text = "\(self.gameScorer.scoreInRound(self.gameScorer.game.currentRound, forTeam: .red))"
        self.blueRoundScoreLabel.text = "\(self.gameScorer.scoreInRound(self.gameScorer.game.currentRound, forTeam: .blue))"
        self.redThrowIndicatorView.isHidden = self.gameScorer.nextTeamToThrow() != .red
        self.blueThrowIndicatorView.isHidden = self.gameScorer.nextTeamToThrow() != .blue
        self.upateBagCountView(self.redBagCountContainerStackView, for: .red)
        self.upateBagCountView(self.blueBagCountContainerStackView, for: .blue)
    }
    
    // Updates the bag indicators that show app below the round's score
    private func upateBagCountView(_ bagCountView: UIStackView, for team: Team) {
        let throwCount = team == .red ? self.gameScorer.numberOfThrowsInRound(self.gameScorer.game.currentRound, forTeam: .red) : self.gameScorer.numberOfThrowsInRound(self.gameScorer.game.currentRound, forTeam: .blue)
        let color = team == .red ? ScoringViewController.redColor : ScoringViewController.blueColor
        let remainingThrows = 4 - throwCount
        
        bagCountView.arrangedSubviews.enumerated().forEach { index, view in
            if remainingThrows > index {
                view.backgroundColor = color
            } else {
                view.backgroundColor = .clear
            }
        }
    }
    
    // These paths are based on where the shapes and sizes of the board and the whole in the original assets
    private func recalculatePaths() {
        self.recalculateHolePath()
        self.recalculateBoardPath()
    }
    
    private func recalculateBoardPath() {
        self.boardPath = UIBezierPath(rect: CGRect(x: self.boardImageView.frame.minX + 23,
                                                   y: self.boardImageView.frame.minY + 16,
                                                   width: 204,
                                                   height: 408))
    }
    
    private func recalculateHolePath() {
        let enclosingRect = CGRect(x: self.boardImageView.frame.minX + 97,
                                   y: self.boardImageView.frame.minY + 68,
                                   width: 56,
                                   height: 56)
        
        self.holePath = UIBezierPath(ovalIn: enclosingRect)
    }
    
    //When is game is finished, we save the gameHistory here to be used for StatsViewController.  Array of gameHistory is saved to UserDefaults
    private func saveGameHistory(){
        let userDefaults = UserDefaults.standard
        var gameHistory = [GameHistory]()
        
        if let gameHistoryData = userDefaults.object(forKey: "gameHistory") as? Data{
            gameHistory = NSKeyedUnarchiver.unarchiveObject(with: gameHistoryData) as! [GameHistory]
        }
        
        gameHistory.append(GameHistory(gameScorer: self.gameScorer))
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: gameHistory), forKey: "gameHistory")
        userDefaults.synchronize()
    }
    

    private func clearAndRefreshForTeam(team: Team){
        self.clearBoard()
        self.refreshSubviewsForTeam(team: team)
    }
 
    // MARK: Actions
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.handleTap(in: sender.location(in: self.playView))
        }
    }
    
    //Used for QA, simulates throws for currentRound
    @IBAction func simulatePressed(_ sender: Any?) {
        self.isSimulating = true
        let totalThrowsToSimulate = (4 - self.gameScorer.numberOfThrowsInRound(self.gameScorer.game.currentRound, forTeam: .red)) +
                                    (4 - self.gameScorer.numberOfThrowsInRound(self.gameScorer.game.currentRound, forTeam: .blue))
        
        for _ in 1...totalThrowsToSimulate{
            let randomX = self.playView.frame.origin.x + CGFloat(arc4random_uniform(UInt32(self.playView.frame.size.width)))
            let randomY = self.playView.frame.origin.y + CGFloat(arc4random_uniform(UInt32(self.playView.frame.size.height)))
            DispatchQueue.main.async {
                self.handleTap(in: CGPoint(x: randomX, y: randomY))
            }
        }
    }

    
}

