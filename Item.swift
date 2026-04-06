//
//  Item.swift
//  MovieLog
//
//  Created by iMac11 on 27/03/2026.
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
