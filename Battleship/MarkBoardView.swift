//
//  MarkBoardView.swift
//  Battleship
//
//  Created by Pei Liu on 11/12/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import UIKit

class MarkBoardView: UIView {
    
    var playerShips: GridView!
    var opponentShips: GridView!
    
    var currentGrid: Board?
    var opponentGrid: Board?
    
    init(frame: CGRect, currentGrid: Board, opponentGrid: Board) {
        super.init(frame: CGRect())
        
        self.currentGrid = currentGrid
        self.opponentGrid = opponentGrid
    
        playerShips = GridView(frame: CGRectMake(10, (frame.width / 8) , frame.width - 20, frame.width - 20), board: currentGrid, touchable: false)
        
        opponentShips = GridView(frame: CGRectMake(10, (frame.width / 8) , frame.width - 20, frame.width - 20), board: opponentGrid, touchable: true)
        addSubview(opponentShips)
        
        print("MarkBoardView init()\n")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
