//
//  OwnerBoardViewController.swift
//  Battleship
//
//  Created by Pei Liu on 11/12/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import UIKit

class OwnerBoardViewController: UIViewController, UIAlertViewDelegate {
    
    var playerBoardView: OwnerBoardView?
    var myBoard : Board?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Singleton.sharedInstance.gameTurn == .player1) {
            myBoard = Singleton.sharedInstance.playerOneBoard!
        } else {
            myBoard = Singleton.sharedInstance.playerTwoBoard!
        }
        
        playerBoardView = OwnerBoardView(frame: view.bounds, currentGrid: myBoard!)
        view = playerBoardView
        view.backgroundColor = .whiteColor()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPointMake(screenWidth * 2 / 4, 30)
        label.textAlignment = NSTextAlignment.Center
        label.text = "This is your sea map"
        self.view.addSubview(label)
        
        let playerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        playerLabel.center = CGPointMake(screenWidth / 2, screenHeight * 10 / 16)
        playerLabel.textAlignment = NSTextAlignment.Center
        if (Singleton.sharedInstance.gameTurn == .player1) {
            playerLabel.text = "Player 1"
        } else {
            playerLabel.text = "Player 2"
        }
        self.view.addSubview(playerLabel)
        
        let launchButton = UIButton(frame: CGRect(x: screenWidth * 2 / 4, y: screenHeight * 14 / 16, width: 120, height: 40))
        launchButton.backgroundColor = .grayColor()
        launchButton.setTitle("Launch Missle", forState: .Normal)
        launchButton.addTarget(self, action: #selector(launchAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(launchButton)
    }
    
    func launchAction(sender: UIButton!) {
        performSegueWithIdentifier("selectingTarget", sender: nil)

    }
}
