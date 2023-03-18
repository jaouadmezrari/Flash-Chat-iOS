//
//  WelcomeViewController.swift
//  Flash Chat
//
//  Created by Abdeljaouad Mezrari on 04/03/2023.
//  Copyright © 2023 Abdeljaouad Mezrari. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let titleWelcome : String = K.appName
        titleLabel.text = ""
        for (index, letter) in titleWelcome.enumerated(){
            Timer.scheduledTimer(withTimeInterval: TimeInterval(0.1 * Double(index)), repeats: false) { (timer) in
                self.titleLabel.text! += "\(letter)"
            }
        }
    }
    
    

}
