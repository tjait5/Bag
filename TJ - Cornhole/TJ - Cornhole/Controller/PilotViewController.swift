//
//  PilotViewController.swift
//  TJ-Cornhole
//
//  Created by Motus on 2/7/18.
//  Copyright © 2018 TJ. All rights reserved.
//

import Foundation
import UIKit

class PilotViewController: UIViewController{
    
    //MARK::Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }    

    //MARK::Actions
    @IBAction func startGamePressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScoringViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func rulesPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RulesViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
}
