//
//  GridColumn.swift
//  Battleship
//
//  Created by Pei Liu on 11/9/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

class GridColumn {
    
    var rows: [myStatus] = []
    var rowCount: Int = Singleton.sharedInstance.size
    
    init() {
        for _ in 0..<rowCount {
            rows.append(myStatus.isWater)
        }
    }
    
    func getStatusFromRow(index: Int) -> myStatus {
        return rows[index]
    }
    
    func setStatusToRow(index: Int, status: myStatus) {
        rows[index] = status
    }
}
