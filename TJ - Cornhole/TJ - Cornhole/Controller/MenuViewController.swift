//
//  MenuViewController.swift
//  TJ-Cornhole
//
//  Created by Motus on 2/2/18.
//  Copyright © 2018 TJ. All rights reserved.
//

import Foundation
import UIKit

protocol MenuDelegate: AnyObject {
    func startNewGame()
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startNewGameButton: UIButton!
    
    let cellReuseIdendifier = "MenuOptionsCell"
    let menuOptions = ["Settings", "Rules", "Stats"]
    weak var delegate: MenuDelegate?
    
    //MARK::Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(OptionsCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MenuViewController.cancel(sender:)))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationItem.title = "Menu"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(delegate != nil){self.startNewGameButton.isHidden = false}else{self.startNewGameButton.isHidden = true}
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK::State Restoration
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(delegate, forKey: "delegate")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let delegateObject = coder.decodeObject(forKey: "delegate") as? MenuDelegate{
            self.delegate = delegateObject
        }
        super.decodeRestorableState(with: coder)
    }
    
    //MARK::TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RulesViewController")
            self.present(vc, animated: true, completion: nil)
        case 2:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StatsViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath) as! OptionsCell
        cell.mainLabel.text = menuOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 3.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }

    //MARK::Navigation Item Actions
    @objc func cancel(sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    //MARK::Actions
    @IBAction func startNewGamePressed(_ sender: Any) {
        delegate?.startNewGame()
        self.presentingViewController?.dismiss(animated: true)
    }
}
