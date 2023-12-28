//
//  LocationSearch.swift
//  Schuma
//
//  Created by Maximilian Köster on 28.12.23.
//

import SwiftUI
import MapKit

struct LocationSearch: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchText = ""
    @State var results = [MKMapItem]()
    @Binding var show: Bool
    @Binding var creation: [LogLocation]
    @State var selectedItem: MKMapItem?
    @State var showResult = 0
    @State var distance = 100
    @State var locationName = ""
    @State var showLocationEdit = false
    @State var didCreation = false
    
    var body: some View {
        if showLocationEdit == false {
            // search list
            
            NavigationStack {
                List (results, id: \.self, selection: $selectedItem) { item in
                    VStack (alignment: .leading) {
                        Text(item.name ?? "no name")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        let adressHelperString = "\(item.placemark.thoroughfare ?? "") \(item.placemark.subThoroughfare ?? "")"
                        if item.name != adressHelperString {
                            Text(adressHelperString)
                        }
                        Text("\(item.placemark.postalCode ?? "no placemark"), \(item.placemark.subLocality ?? "no placemark"), \(item.placemark.locality ?? "no placemark"), \(item.placemark.country ?? "no placemark")")
                        Text("\(item.placemark.location!.coordinate.latitude) - \(item.placemark.location!.coordinate.longitude)")
                    }
                }
                .onChange(of: selectedItem, { old, new in
                    showLocationEdit = true
                })
                .navigationTitle("Adresssuche")
                .navigationBarTitleDisplayMode(.inline)
            }
            .searchable(text: $searchText)
            .disableAutocorrection(true)
            .onSubmit(of: .search) {
                if searchText == "A54-03" {
                    creation = getLocationsA54()
                    for location in creation {
                        modelContext.insert(location)
                    }
                    show = false
                } else {
                    Task { await searchPlaces() }
                }
            }
            .onChange(of: searchText, {
                //Task { await searchPlaces() }
            })
        } else if showLocationEdit {
            let adressStringStreet = "\(selectedItem!.placemark.thoroughfare ?? "") \(selectedItem!.placemark.subThoroughfare ?? "")"
            let adressStringLocality = "\(selectedItem!.placemark.postalCode ?? "no placemark"), \(selectedItem!.placemark.subLocality ?? "no placemark"), \(selectedItem!.placemark.locality ?? "no placemark"), \(selectedItem!.placemark.country ?? "no placemark")"
            let editLocation = LogLocation(title: selectedItem!.name ?? "no name", latitude: selectedItem!.placemark.coordinate.latitude, longitude: selectedItem!.placemark.coordinate.longitude, adressString: "not implemented", adressStringStreet: adressStringStreet, adressStringLocality: adressStringLocality, logging: true)
            
            LocationEdit(show: $showLocationEdit, showParent: $show, creation: $creation, logLocation: editLocation, creationMode: true)
                .onChange(of: didCreation, {
                    show.toggle()
                })
                        
        }
            //LocationEdit(show: $showLocationEdit, logLocation: LogLocation(title: "dummy title", addressStringStreet: "dummy title", latitude: 0, longitude: 0, adressString: "dummy adress"))
    }
}

extension LocationSearch {
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 52.4817788, longitude: 13.4405595), latitudinalMeters: 100000, longitudinalMeters: 100000)
        
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
        print("search done")
    }
}

/*
#Preview {
    LocationSearch(show: .constant(false), creation: .constant(nil))
}
*/
