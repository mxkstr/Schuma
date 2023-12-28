//
//  Item.swift
//  Schuma
//
//  Created by Maximilian Köster on 28.12.23.
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
