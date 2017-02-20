//
//  MarkBoardViewController.swift
//  Battleship
//
//  Created by Pei Liu on 11/12/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import UIKit

class MarkBoardViewController: UIViewController, UIAlertViewDelegate {
    
    var launchButton: UIButton?
    var nextButton: UIButton?
    var p1_BoardView: MarkBoardView?
    var p2_BoardView: MarkBoardView?
    let board1 = Singleton.sharedInstance.playerOneBoard!
    let board2 = Singleton.sharedInstance.playerTwoBoard!
    var p1_LastFireLocation: (row: Int, col: Int) = (-1, -1)
    var p2_LastFireLocation: (row: Int, col: Int) = (-1, -1)
    var popUpMessage: UIAlertView = UIAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpMessage.addButtonWithTitle("OK")
        p1_BoardView = MarkBoardView(frame: view.bounds, currentGrid: board1, opponentGrid: board2)
        p2_BoardView = MarkBoardView(frame: view.bounds, currentGrid: board2, opponentGrid: board1)
        
        if (Singleton.sharedInstance.gameTurn == .player1) {
            view = p1_BoardView
        } else {
            view = p2_BoardView
        }
        view.backgroundColor = .whiteColor()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(screenWidth * 2 / 4, 30)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Select a target to attack!"
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
        
        launchButton = UIButton(frame: CGRect(x: screenWidth * 2 / 4, y: screenHeight * 14 / 16, width: 120, height: 40))
        launchButton!.backgroundColor = .grayColor()
        launchButton!.setTitle("Attack This", forState: .Normal)
        launchButton!.addTarget(self, action: #selector(launchAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(launchButton!)
        
        nextButton = UIButton(frame: CGRect(x: screenWidth * 2 / 4, y: screenHeight * 14 / 16, width: 120, height: 40))
        nextButton!.backgroundColor = .grayColor()
        nextButton!.setTitle("Finished", forState: .Normal)
        nextButton!.addTarget(self, action: #selector(nextAction), forControlEvents: .TouchUpInside)
    }
    
    func launchAction(sender: UIButton!) {
        if (Singleton.sharedInstance.gameTurn == .player1) {
            if (!p1_FiredMissle()) {
                return
            }
            Singleton.sharedInstance.gameTurn = .player2
        } else {
            if (!p2_FiredMissle()) {
                return
            }
            Singleton.sharedInstance.gameTurn = .player1
        }
        
        self.p1_BoardView?.setNeedsDisplay()
        self.p2_BoardView?.setNeedsDisplay()
        launchButton!.removeFromSuperview()
        self.view.addSubview(nextButton!)
    }
    
    func nextAction(sender: UIButton!) {
        performSegueWithIdentifier("toTransit", sender: nil)
    }
    
    func updateAll() {
        p1_BoardView!.playerShips.updateGridStatus()
        Singleton.sharedInstance.playerOneBoard = p1_BoardView!.playerShips.myBoard
        p2_BoardView!.playerShips.updateGridStatus()
        Singleton.sharedInstance.playerTwoBoard = p2_BoardView!.playerShips.myBoard
    }
    
    func p1_FiredMissle() -> Bool{
        // If player does not select one return false right away
        if(p1_BoardView!.opponentShips.selectedLocation == nil) {
            notSeletedMsg()
            return false
        }
        
        // Make sure not select the previous button
        let location = p1_BoardView!.opponentShips.buttonTouched
        let row: Int = location.row
        let column: Int = location.col
        
        if(row == p1_LastFireLocation.row && column == p1_LastFireLocation.col) {
            return false
        }
        else{
            p1_LastFireLocation = (row, column)
        }
        
        // Get location Status from Player2
        let locationStatus = Singleton.sharedInstance.playerTwoBoard!.map.getStatusFromLocation(column, row: row)
        
        if locationStatus == .isWater {
            // Update both views for a miss
            self.p1_BoardView!.opponentShips.buttonTouched((row: row, col: column), with: .isMissed)
            self.p2_BoardView!.playerShips.buttonTouched((row: row, col: column), with: .isMissed)
            updateAll()
            missedMsg()
            
        } else if locationStatus == .isShip {
            // Update both views for a hit
            self.p1_BoardView!.opponentShips.buttonTouched((row: row, col: column), with: .isHit)
            self.p2_BoardView!.playerShips.buttonTouched((row: row, col: column), with: .isSunk)
            Singleton.sharedInstance.playOneHitCount = Singleton.sharedInstance.playOneHitCount + 1
            updateAll()
            
            // Check player if win or not
            let totalShipSize = 2 + 3 + 3 + 4 + 5
            if(Singleton.sharedInstance.playOneHitCount == totalShipSize){
                wonMsg()
                resetGame()
                performSegueWithIdentifier("toWin", sender: nil)
            } else{
                hitMsg()
            }
        } else {
            print("There is am invalid state in the board!")
        }
        return true
    }
    
    func p2_FiredMissle() -> Bool{
        // If player does not select one return false right away
        if(p2_BoardView!.opponentShips.selectedLocation == nil) {
            notSeletedMsg()
            return false
        }
        
        // Make sure not select the previous button
        let location = p2_BoardView!.opponentShips.buttonTouched
        let row: Int = location.row
        let column: Int = location.col
        
        if(row == p2_LastFireLocation.row && column == p2_LastFireLocation.col) {
            return false
        }
        else{
            p2_LastFireLocation = (row, column)
        }
        
        // Get location Status from Player1
        let locationStatus = Singleton.sharedInstance.playerOneBoard!.map.getStatusFromLocation(column, row: row)
        
        if locationStatus == .isWater {
            // Update both views for a miss
            self.p2_BoardView!.opponentShips.buttonTouched((row: row, col: column), with: .isMissed)
            self.p1_BoardView!.playerShips.buttonTouched((row: row, col: column), with: .isMissed)
            updateAll()
            missedMsg()
            
        } else if locationStatus == .isShip {
            // Update both views for a hit
            self.p2_BoardView!.opponentShips.buttonTouched((row: row, col: column), with: .isHit)
            self.p1_BoardView!.playerShips.buttonTouched((row: row, col: column), with: .isSunk)
            Singleton.sharedInstance.playTwoHitCount = Singleton.sharedInstance.playTwoHitCount + 1
            updateAll()
            
            // Check player if win or not
            let totalShipSize = 2 + 3 + 3 + 4 + 5
            if(Singleton.sharedInstance.playTwoHitCount == totalShipSize){
                wonMsg()
                resetGame()
                performSegueWithIdentifier("toWin", sender: nil)
            } else{
                hitMsg()
            }
        } else {
            print("There is am invalid state in the board!")
        }
        return true
    }
    
    func resetGame() {
        Singleton.sharedInstance.gameTurn = .player1
        Singleton.sharedInstance.playOneHitCount = 0
        Singleton.sharedInstance.playTwoHitCount = 0
        Singleton.sharedInstance.isReadyToPlay = false
        
        p1_BoardView!.playerShips.resetStatus()
        Singleton.sharedInstance.playerOneBoard = p1_BoardView!.playerShips.myBoard
        p2_BoardView!.playerShips.resetStatus()
        Singleton.sharedInstance.playerTwoBoard = p2_BoardView!.playerShips.myBoard
    }

    func wonMsg() {
        popUpMessage.title = "You sunk all opponent's ships, You won!"
        popUpMessage.show()
    }
    
    func hitMsg() {
        popUpMessage.title = "BOOM! You hit opponent's ship!"
        popUpMessage.show()
    }
    
    func missedMsg() {
        popUpMessage.title = "Sorry you missed it!"
        popUpMessage.show()
    }
    
    func notSeletedMsg() {
        popUpMessage.title = "OOPS! Please select a location to attack."
        popUpMessage.show()
    }

}
