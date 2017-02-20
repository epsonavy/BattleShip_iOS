//
//  RuleViewController.swift
//  Battleship
//
//  Created by Pei Liu on 11/8/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import UIKit

class RuleViewController: UIViewController {
    
    
    @IBAction func goBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
