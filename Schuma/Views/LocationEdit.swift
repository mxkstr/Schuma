//
//  LocationEdit.swift
//  Schuma
//
//  Created by Maximilian Köster on 28.12.23.
//

import SwiftUI
import MapKit


struct LocationEdit: View {
    @Environment(\.modelContext) private var modelContext
    
    @Binding var show: Bool
    @Binding var showParent: Bool
    @Binding var creation: [LogLocation]
    
    @State var logLocation: LogLocation
    
    @State var creationMode = false
    @State var locationName = ""
    
    @State var distance = 100

    var body: some View {
        List {
            // map section
            // ---
            Section {
                VStack (alignment: .leading) {
                    Text(logLocation.title)
                        .fontWeight(.bold)
                    if logLocation.title != logLocation.adressStringStreet {
                        Text(logLocation.adressStringStreet)
                    }
                    Text(logLocation.adressStringLocality)
                }
                
                Map() {
                    Marker(logLocation.title, coordinate: CLLocationCoordinate2D(latitude: logLocation.latitude, longitude: logLocation.longitude))
                        .tint(.gray)
                }
                .frame(minHeight: 200)
                
                Stepper(value: $distance, in: 10...2000, step: 10, label: {
                    Text("Radius \(distance) m")
                })
            }
            
            // name section
            //---
            Section ("name") {
                TextField(logLocation.title, text: $locationName)
                    .disableAutocorrection(true)
                    .onSubmit {
                        logLocation.title = locationName
                    }
            }
            
            // Button section
            // ---
            Button("Speichern") {
                print("speichern")
                
                if creationMode {
                    modelContext.insert(logLocation)
                    //locationManagerDelegate.monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: logLocation.latitude, longitude: logLocation.longitude), radius: 100.0, identifier: logLocation.uuid.uuidString)
                    creation.append(logLocation)
                    showParent.toggle()
                    show.toggle()
                }
                
            }.disabled(!creationMode)
            Button("zurück") {
                print("zurück")
                show.toggle()
            }
        }
        .onAppear {
            //locationName = logLocation.title
        }
    }
}
