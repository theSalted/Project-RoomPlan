//
//  Item.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/3/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
