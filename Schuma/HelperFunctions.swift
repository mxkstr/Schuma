//
//  HelperFunctions.swift
//  Schuma
//
//  Created by Maximilian Köster on 28.12.23.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit

func getDateString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yy"
    return formatter.string(from: date)
}

func splitDate(date: Date) -> [Int] {
    var result = [Int]()
    let formats = ["HH", "mm"]
    
    for format in formats {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let item = formatter.string(from: date)
        result.append(Int(item) ?? -1)
    }
    
    return result
}

func stopMonitoringVisits(uuid: UUID) {
    let locationManager = CLLocationManager()
    for region in locationManager.monitoredRegions {
        if region.identifier == uuid.uuidString {
            locationManager.stopMonitoring(for: region)
        }
    }
    
}

func getLocationsA54() -> [LogLocation] {
    var result = [LogLocation]()
    
    let a54 = LogLocation(title: "A 54", latitude: 52.481649, longitude: 13.440637, adressString: "not implemented", adressStringStreet: "Sonnenallee 107", adressStringLocality: "12045, Neukölln, Berlin, Deutschland", logging: true, orderValue: 0)
    result.append(a54)
    
    let s282 = LogLocation(title: "Agentur für Arbeit Berlin Süd", latitude: 52.469833, longitude: 13.464806, adressString: "not implemented", adressStringStreet: "Sonnenallee 282", adressStringLocality: "12057, Neukölln, Berlin, Deutschland", logging: true, orderValue: 1)
    result.append(s282)
    
    let s318 = LogLocation(title: "Jobcenter Berlin Neukölln", latitude: 52.464250, longitude: 13.472208, adressString: "not implemented", adressStringStreet: "Sonnenallee 318", adressStringLocality: "12057, Neukölln, Berlin, Deutschland", logging: true, orderValue: 2)
    result.append(s318)
    
    let k83 = LogLocation(title: "Rathaus Neukölln", latitude: 52.481326, longitude: 13.434983, adressString: "not implemented", adressStringStreet: "Karl-Marx-Straße 83", adressStringLocality: "12043, Neukölln, Berlin, Deutschland", logging: true, orderValue: 3)
    result.append(k83)
    
    let f54 = LogLocation(title: "Hausgemeinschaft F 54", latitude: 52.488697, longitude: 13.427656, adressString: "not implemented", adressStringStreet: "Friedelstraße 54", adressStringLocality: "12047, Neukölln, Berlin, Deutschland", logging: true, orderValue: 4)
    result.append(f54)
    
    let w84 = LogLocation(title: "Wohnung Fr. Moser", latitude: 52.483393, longitude: 13.442156, adressString: "not implemented", adressStringStreet: "Wildenbruchstraße 84", adressStringLocality: "12045, Neukölln, Berlin, Deutschland", logging: true, orderValue: 5)
    result.append(w84)
    
    let i36 = LogLocation(title: "Dönmez", latitude: 52.481343, longitude: 13.444224, adressString: "not implemented", adressStringStreet: "Innstraße 36/38", adressStringLocality: "12045, Neukölln, Berlin, Deutschland", logging: true, orderValue: 6)
    result.append(i36)
    
    let s27 = LogLocation(title: "Fam. Remmo (vs. A. Tit)", latitude: 52.472015, longitude: 13.435658, adressString: "not implemented", adressStringStreet: "Schudomastraße 27", adressStringLocality: "12055, Neukölln, Berlin, Deutschland", logging: true, orderValue: 7)
    result.append(s27)
    
    let k14 = LogLocation(title: "Lokal \"Zum Heinzelmann\"", latitude: 52.473782, longitude: 13.442292, adressString: "not implemented", adressStringStreet: "Karl-Marx-Platz 14", adressStringLocality: "12043, Neukölln, Berlin, Deutschland", logging: true, orderValue: 8)
    result.append(k14)
    
    let r76 = LogLocation(title: "Lokal \"AVIV 030\"", latitude: 52.474806, longitude: 13.444819, adressString: "not implemented", adressStringStreet: "Richardstraße 76", adressStringLocality: "12043, Neukölln, Berlin, Deutschland", logging: true, orderValue: 9)
    result.append(r76)
    
    return result
}
