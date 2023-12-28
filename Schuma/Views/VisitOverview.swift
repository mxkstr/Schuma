//
//  VisitOverview.swift
//  Schuma
//
//  Created by Maximilian Köster on 28.12.23.
//

import SwiftUI
import SwiftData

struct VisitOverview: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LogLocation.orderValue) private var locations: [LogLocation]
    @Query(sort: \LocationVisit.timeStamp, order: .reverse) private var visits: [LocationVisit]
    
    @Binding var show: Bool
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(locations) { location in
                    Section (location.title) {
                        ForEach (visits) { visit in
                            if visit.locationUUID == location.uuid {
                                VStack(alignment: .leading) {
                                    Text("\(visit.timeStamp.formatted())")
                                        .fontWeight(.semibold)
                                    let splitted = splitDate(date: visit.timeStamp)
                                    Text("Schuma: -\(splitted[0] + 1):\(splitted[1])")
                                }
                            }
                        }
                        if !visited(uuid: location.uuid) {
                            Text("keine Besuche")
                        }
                    }
                }
            }
            .navigationTitle("Doku")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    //showEditor = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
    }
    
    func visited(uuid: UUID) -> Bool {
        for visit in visits {
            if visit.locationUUID == uuid {
                return true
            }
        }
        return false
    }
}
