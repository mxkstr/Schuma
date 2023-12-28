//
//  LocationOverview.swift
//  Schuma
//
//  Created by Maximilian Köster on 28.12.23.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit

struct LocationOverview: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LocationVisit.timeStamp, order: .reverse) private var visitArray: [LocationVisit]
    
    @Binding var show: Bool
    @State var showEditor = false
    
    @State var logLocation: LogLocation
    
    var locationManager = CLLocationManager()
    
    var body: some View {
        NavigationStack {
            List {
                // title section
                /*
                Section {
                    VStack (alignment: .leading) {
                        Text(logLocation.title)
                            .fontWeight(.bold)
                        if logLocation.title != logLocation.adressStringStreet {
                            Text(logLocation.adressStringStreet)
                        }
                        Text(logLocation.adressStringLocality)
                    }
                }
                */
                 
                // visit section
                Section ("Letzte Besuche") {
                    ForEach (visitArray) { visit in
                        if visit.locationUUID == logLocation.uuid {
                            VStack(alignment: .leading) {
                                Text("\(visit.timeStamp.formatted())")
                                    .fontWeight(.semibold)
                                let splitted = splitDate(date: visit.timeStamp)
                                Text("Schuma: -\(splitted[0] + 1):\(splitted[1])")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showEditor, onDismiss: {
                showEditor = false
            }, content: {
                Button ("löschen") {
                    stopMonitoringVisits(uuid: logLocation.uuid)
                    modelContext.delete(logLocation)
                    showEditor = false
                    show = false
                }
            })
            .presentationDetents([.medium])
            
            .navigationTitle(logLocation.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    showEditor = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                    /*
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                     */
                }
            }
        }
    }
}

/*
#Preview {
    LocationOverview(show: .constant(false), logLocation: LogLocation(title: "PreviewLocation", latitude: 0, longitude: 0, adressString: "PreviewAdress"))
}
*/
