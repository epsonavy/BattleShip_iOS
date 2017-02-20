//
//  Grid.swift
//  Battleship
//
//  Created by Pei Liu on 11/9/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

class Grid {
    var columns: [GridColumn] = [GridColumn]()
    var columnCount = Singleton.sharedInstance.size
    
    init() {
        for _ in 0..<columnCount {
            columns.append(GridColumn())
        }
    }
    
    func getStatusFromLocation(col: Int, row: Int) -> myStatus {
        return columns[col].getStatusFromRow(row)
    }
    
    func updateStatus(col: Int, row: Int, code: myStatus) {
        columns[col].setStatusToRow(row, status: code)
    }
}
