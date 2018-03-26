//
//  SettingsViewController.swift
//  TJ-Cornhole
//
//  Created by Motus on 2/2/18.
//  Copyright © 2018 TJ. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var isExact:  Bool
    let cellReuseIdendifier = "SettingsOptionsCell"
    let settingsOptions = ["First to 21 points and win by 2", "First to 21 points exactly"]
    
    //MARK::Init
    required init?(coder aDecoder: NSCoder) {
        self.isExact = UserDefaults.standard.bool(forKey: "ruleState")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(OptionsCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK::TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDefaults = UserDefaults.standard
        let nav = self.navigationController as! MenuNavigationController
        switch indexPath.row {
        case 0:
            userDefaults.set(false, forKey:"ruleState")
            self.isExact = false
            break;
        case 1:
            userDefaults.set(true, forKey:"ruleState")
            self.isExact = true
            break;
        default:
            break;
        }
        
        nav.gameScorer.setRuleState(for: self.isExact)
        userDefaults.synchronize()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath) as! OptionsCell
        if((self.isExact && indexPath.row == 1) || (!self.isExact && indexPath.row == 0)){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryType.none;
        }
        
        cell.mainLabel.text = settingsOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 2.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
}
