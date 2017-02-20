//
//  CellButtonDelegate.swift
//  Battleship
//
//  Created by Pei Liu on 11/9/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

protocol CellButtonDelegate: class {
    func updateButton(row: Int, col: Int)
}
