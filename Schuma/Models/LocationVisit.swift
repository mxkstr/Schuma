//
//  LocationVisit.swift
//  Schuma
//
//  Created by Maximilian Köster on 28.12.23.
//

import Foundation
import SwiftData

@Model
final class LocationVisit {
    var uuid: UUID
    var locationUUID: UUID
    var timeStamp: Date
    
    init(uuid: UUID = UUID(), locationUUID: UUID, timeStamp: Date) {
        self.uuid = uuid
        self.locationUUID = locationUUID
        self.timeStamp = timeStamp
    }
}
