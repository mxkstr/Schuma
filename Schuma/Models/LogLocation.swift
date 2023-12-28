//
//  LogLocation.swift
//  Schuma
//
//  Created by Maximilian Köster on 28.12.23.
//

import Foundation
import SwiftData

@Model
final class LogLocation {
    var uuid: UUID
    var title: String
    var latitude: Double
    var longitude: Double
    var adressString: String
    var adressStringStreet: String
    var adressStringLocality: String
    var logging: Bool
    var loggingActivationStatus: Bool
    
    init(uuid: UUID = UUID(), title: String, latitude: Double, longitude: Double, adressString: String, adressStringStreet: String = "", adressStringLocality: String = "", logging: Bool, loggingActivationStatus: Bool = false) {
        self.uuid = uuid
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.adressString = adressString
        self.adressStringStreet = adressStringStreet
        self.adressStringLocality = adressStringLocality
        self.logging = logging
        self.loggingActivationStatus = loggingActivationStatus
    }
}
