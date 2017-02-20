//
//  Singleton.swift
//  Battleship
//
//  Created by Pei Liu on 11/8/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import Foundation
import UIKit

class Singleton{
    static let sharedInstance = Singleton()
    
    enum whoTurn {
        case player1
        case player2
    }
    
    var gameTurn = whoTurn.player1
    
    // The board size, default battleship size is 10 X 10
    let size = 10
    
    let waterColor = UIColor(red: 120/255, green: 180/255, blue: 255/255, alpha: 1.0)
    let shipColor = UIColor.darkGrayColor()
    let sunkColor = UIColor(red: 147/255, green: 113/255, blue: 0/255, alpha: 1.0)
    
    // isReadyToPlay = false: put all ships in the board first
    var isReadyToPlay = false
    
    var playerOneBoard: Board?
    var playerTwoBoard: Board?

    var playOneHitCount = 0
    var playTwoHitCount = 0
}
