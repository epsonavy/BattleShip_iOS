//
//  GridView.swift
//  Battleship
//
//  Created by Pei Liu on 11/9/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import UIKit

class GridView: UIView, CellButtonDelegate {
    
    let max_width = (UInt32)(Singleton.sharedInstance.size)
    let max_height = (UInt32)(Singleton.sharedInstance.size)
    var ship1: Ship = Ship(name: "ship1", size: 2)
    var ship2: Ship = Ship(name: "ship2", size: 3)
    var ship3: Ship = Ship(name: "ship3", size: 3)
    var ship4: Ship = Ship(name: "ship4", size: 4)
    var ship5: Ship = Ship(name: "ship5", size: 5)
    var max_w = Singleton.sharedInstance.size
    var max_h = Singleton.sharedInstance.size
    var map: (width: Int, height: Int) = (Singleton.sharedInstance.size, Singleton.sharedInstance.size)
    var isVisible: Bool = true
    var selectedLocation: (row: Int, col: Int)?
    var lastLocation: (row: Int, col: Int)?
    var myBoard: Board?
    
    init(frame: CGRect, board: Board, touchable: Bool) {
        super.init(frame: frame)
        myBoard = board
        isVisible = touchable
        addButtonsOnGrid(board, touchable: touchable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Add the buttons on grid with status
    private func addButtonsOnGrid(grid: Board, touchable: Bool){
        userInteractionEnabled = touchable
        for rowIndex in 0..<max_h {
            for colIndex in 0..<max_w {
                let buttonFrame = CGRectMake(CGFloat(rowIndex) * (bounds.size.width / CGFloat(max_h)), CGFloat(colIndex) * (bounds.size.height / CGFloat(max_w)), bounds.size.width / CGFloat(max_h), bounds.size.height / CGFloat(max_h))
                let cell = CellButton(frame: buttonFrame, delegate: self)
                let status = grid.map.getStatusFromLocation(colIndex, row: rowIndex)
                if((touchable && status != .isShip) || !touchable) {
                    cell.buttonCurrentStatus = status
                }
                cell.x  = rowIndex
                cell.y = colIndex
                addSubview(cell)
                
            }
        }
        print("gridView: Finished adding all Cellbuttons\n")
    }
    
    // Update the button
    func updateButton(row: Int, col: Int){
        buttonTouched = (row, col)
    }
    
    // Select that button and highlight it, let user can confirm his choice.
    var buttonTouched: (row: Int, col: Int) {
        get {
            return selectedLocation!
        }
        set {
            selectedLocation = newValue
            
            if (Singleton.sharedInstance.isReadyToPlay) {
                if (!previousButtonIsVisited()) {
                    if(lastLocation != nil){
                        buttonTouched(lastLocation!, with: .isWater)
                    }
                    lastLocation = newValue
                }
                buttonTouched(newValue, with: .isSelected)
            } else {
                if(checkButtonStatus(selectedLocation!) == .isShip){
                    if(lastLocation != nil){
                        buttonTouched(selectedLocation!, with: .isWater)
                    }
                    lastLocation = newValue
                } else if (checkButtonStatus(selectedLocation!) == .isWater) {
                    buttonTouched(newValue, with: .isShip)
                }
            }
        }
    }

    // Updated with specific status
    func buttonTouched(location: (row: Int, col: Int), with status: myStatus) {
        (subviews[location.row * max_w + location.col] as! CellButton).buttonCurrentStatus = status
    }
    
    // Check button status
    func checkButtonStatus(location: (row: Int, col: Int)) -> myStatus {
        return (subviews[location.row * max_w + location.col] as! CellButton).buttonCurrentStatus
    }
    
    // Save player's ship
    func updateGridStatus() {
        for cell in subviews {
            myBoard!.map.updateStatus((cell as! CellButton).y, row: (cell as! CellButton).x, code: (cell as! CellButton).buttonCurrentStatus)
        }
    }
    
    // Verify ships in the map == total size 17
    func verifyShips() -> Bool {
        var total = 0
        for cell in subviews {
            if ((cell as! CellButton).buttonCurrentStatus == .isShip) {
                total = total + 1
            }
        }
        if (total == 17) {
            return true
        } else {
            return false
        }
    }
    
    
    // Reset status
    func resetStatus() {
        for cell in subviews {
            (cell as! CellButton).buttonCurrentStatus = .isWater
        }
    }
    
    // No duplicate selection
    func previousButtonIsVisited() -> Bool{
        if(lastLocation == nil){
            return false
        }
        return (selectedLocation!.row == lastLocation!.row && selectedLocation!.col == lastLocation!.col)
    }

    func randomize() {
        randomPlacedInMap(ship1)
        randomPlacedInMap(ship2)
        randomPlacedInMap(ship3)
        randomPlacedInMap(ship4)
        randomPlacedInMap(ship5)
    }
    
    private func randomPlacedInMap(ship: Ship) {
        let orientation: Int = (Int)(arc4random_uniform(2))
        var shipPlaced = false
        
        if(orientation == 0) {
            while(!shipPlaced){
                shipPlaced = randomPlaceShipHorizontally(ship.size)
            }
        } else {
            while(!shipPlaced){
                shipPlaced = randomPlaceShipVertically(ship.size)
            }
        }
    }
    
    func randomPlaceShipHorizontally(spaceSize: Int) -> Bool {
        
        var columnIndex: Int = (Int)(arc4random_uniform(max_width))
        var rowIndex: Int = (Int)(arc4random_uniform(max_height))
        
        while (columnIndex + spaceSize > 9) {
            columnIndex = (Int)(arc4random_uniform(max_width))
            rowIndex = (Int)(arc4random_uniform(max_height))
        }
        
        for index in 0..<spaceSize {
            if(checkButtonStatus((rowIndex, col: columnIndex + index)) == .isShip) {
                return false
            }
        }
        
        for index in 0..<spaceSize {
            print("\(rowIndex),\(columnIndex + index)\n")
            buttonTouched((row: rowIndex, col: columnIndex + index), with: .isShip)
        }
        return true
    }
    
    
    func randomPlaceShipVertically(spaceSize: Int) -> Bool {
        
        var columnIndex: Int = (Int)(arc4random_uniform(max_width))
        var rowIndex: Int = (Int)(arc4random_uniform(max_height))
        
        while (rowIndex + spaceSize >= Singleton.sharedInstance.size) {
            columnIndex = (Int)(arc4random_uniform(max_width))
            rowIndex = (Int)(arc4random_uniform(max_height))
        }
        
        for index in 0..<spaceSize {
            if(checkButtonStatus((rowIndex + index, col: columnIndex)) == .isShip) {
                return false
            }
        }
        
        for index in 0..<spaceSize{
            print("\(rowIndex + index),\(columnIndex)\n")
            buttonTouched((row: rowIndex + index, col: columnIndex), with: .isShip)
        }
        return true
    }

}
