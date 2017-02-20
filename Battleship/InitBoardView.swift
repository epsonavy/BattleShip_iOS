//
//  InitBoardView.swift
//  Battleship
//
//  Created by Pei Liu on 11/9/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import UIKit

class InitBoardView: UIView {
    
    var playerShips: GridView!

    var myBoard: Board?
    
    init(frame: CGRect, currentGrid: Board) {
        super.init(frame: CGRect())
        
        myBoard = currentGrid      // Player need to put ships to the board
        
        playerShips = GridView(frame: CGRectMake(10, (frame.width / 8) , frame.width - 20, frame.width - 20), board: currentGrid, touchable: true)
        addSubview(playerShips)
        
        print("InitBoardView init()\n")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
