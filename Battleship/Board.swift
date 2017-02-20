//
//  Board.swift
//  Battleship
//
//  Created by Pei Liu on 11/8/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import Foundation

class Board {

    var map: Grid = Grid()
    
    var ship1: Ship = Ship(name: "ship1", size: 2)
    var ship2: Ship = Ship(name: "ship2", size: 3)
    var ship3: Ship = Ship(name: "ship3", size: 3)
    var ship4: Ship = Ship(name: "ship4", size: 4)
    var ship5: Ship = Ship(name: "ship5", size: 5)

}

