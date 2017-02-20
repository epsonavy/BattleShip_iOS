//
//  InitBoardViewController.swift
//  Battleship
//
//  Created by Pei Liu on 11/9/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import UIKit

class InitBoardViewController: UIViewController, UIAlertViewDelegate {
    
    var playerBoardView: InitBoardView?
    var imgs = [UIImageView: Int]()
    var currentImg : UIImageView?
    var popUpMessage: UIAlertView = UIAlertView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpMessage.addButtonWithTitle("OK")
        playerBoardView = InitBoardView(frame: view.bounds, currentGrid: Board())
        view = playerBoardView
        view.backgroundColor = .whiteColor()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let imageView1
            = UIImageView(frame: CGRectMake(screenWidth / 8, screenHeight * 10 / 16, 73, 38))
        let image1 = UIImage(named: "ship2.png")
        imageView1.image = image1
        
        let imageView2
            = UIImageView(frame: CGRectMake(screenWidth / 8, screenHeight * 11 / 16, 110, 37))
        let image2 = UIImage(named: "ship3.png")
        imageView2.image = image2

        
        let imageView3
            = UIImageView(frame: CGRectMake(screenWidth / 8, screenHeight * 12 / 16, 110, 37))
        let image3 = UIImage(named: "ship3.png")
        imageView3.image = image3

        let imageView4
            = UIImageView(frame: CGRectMake(screenWidth / 2, screenHeight * 11 / 16, 144, 36))
        let image4 = UIImage(named: "ship4.png")
        imageView4.image = image4

        
        let imageView5
            = UIImageView(frame: CGRectMake(screenWidth / 2, screenHeight * 12 / 16, 180, 40))
        let image5 = UIImage(named: "ship5.png")
        imageView5.image = image5
        
        imgs[imageView1] = 2
        imgs[imageView2] = 3
        imgs[imageView3] = 3
        imgs[imageView4] = 4
        imgs[imageView5] = 5

        for img in imgs.keys {
            img.alpha = 0.7
            img.userInteractionEnabled = true
            img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InitBoardViewController.imageTapped(_:))))
            self.view.addSubview(img)
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
        label.center = CGPointMake(screenWidth * 2 / 4, 30)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Please put 17 ship blocks in the map"
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
        
        let randomButton = UIButton(frame: CGRect(x: screenWidth * 1 / 4, y: screenHeight * 14 / 16, width: 80, height: 40))
        randomButton.backgroundColor = .grayColor()
        randomButton.setTitle("Random", forState: .Normal)
        randomButton.addTarget(self, action: #selector(randomAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(randomButton)
        
        let nextButton = UIButton(frame: CGRect(x: screenWidth * 2 / 4, y: screenHeight * 14 / 16, width: 80, height: 40))
        nextButton.backgroundColor = .grayColor()
        nextButton.setTitle("Ready", forState: .Normal)
        nextButton.addTarget(self, action: #selector(nextAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(nextButton)
        
        let resetButton = UIButton(frame: CGRect(x: screenWidth * 3 / 4, y: screenHeight * 14 / 16, width: 80, height: 40))
        resetButton.backgroundColor = .grayColor()
        resetButton.setTitle("Reset", forState: .Normal)
        resetButton.addTarget(self, action: #selector(resetAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(resetButton)
        
    }
    
    func randomAction(sender: UIButton!) {
        playerBoardView?.playerShips.resetStatus()
        playerBoardView?.playerShips.randomize()
    }
    
    func nextAction(sender: UIButton!) {
        if(!(playerBoardView?.playerShips.verifyShips())!) {
            wrongMsg()
        } else {
            if(Singleton.sharedInstance.gameTurn == .player2 ) {
                Singleton.sharedInstance.gameTurn = .player1
                playerBoardView?.playerShips.updateGridStatus()
                Singleton.sharedInstance.playerTwoBoard = (playerBoardView?.myBoard)!
                Singleton.sharedInstance.isReadyToPlay = true
                performSegueWithIdentifier("boardsReady", sender: nil)
            } else {
                Singleton.sharedInstance.gameTurn = .player2
                playerBoardView?.playerShips.updateGridStatus()
                Singleton.sharedInstance.playerOneBoard = (playerBoardView?.myBoard)!
                performSegueWithIdentifier("nextPlayer", sender: nil)
            }
        }
    }
    
    func wrongMsg() {
        popUpMessage.title = "You must have exactly 17 ship blocks in the map!"
        popUpMessage.show()
    }
    
    func resetAction(sender: UIButton!) {
        playerBoardView?.playerShips.resetStatus()
    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        let tappedImg = gestureRecognizer.view!
        currentImg = tappedImg as? UIImageView
        for img in imgs.keys {
            if (img == tappedImg) {
                img.alpha = 1
            } else {
                img.alpha = 0.7
            }
        }
    }
}
