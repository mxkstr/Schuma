//
//  HelperFunctions.swift
//  Schuma
//
//  Created by Maximilian Köster on 28.12.23.
//

import Foundation

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
