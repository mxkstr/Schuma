//
//  ContentView.swift
//  Schuma
//
//  Created by Maximilian Köster on 28.12.23.
//

import SwiftUI
import SwiftData
import MapKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var logLocationArray: [LogLocation]
    @State private var mapSelection: LogLocation?
    @State private var showLocationEditor = false
    @State private var showLocationSearch = false
    @State private var showVisitOverview = false
    @State private var showButtons = false
    @State private var showDummy = false
    @State private var locationToEdit: LogLocation?
    
    // vars for location creation and monitoring
    @State private var newLocation = [LogLocation]()
    
    //@StateObject private var locationManagerDelegate = LocationManagerDelegate()
    @State private var dataManagerVisit: DataManagerVisit
    
    let locationManager = CLLocationManager()

    var body: some View {
        
        Map(selection: $mapSelection) {
            // user location annotation
            UserAnnotation()
            
            // locations
            ForEach(logLocationArray) { location in
                Marker(location.title, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    .tint(.gray)
                    .tag(location)
            }
        }
        .mapControls {
            MapCompass()
        }
        .onAppear {
            // request location
            // ---
            locationManager.requestAlwaysAuthorization()
            
            // request notifications
            // ---
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        .onChange(of: mapSelection, { oldValue, newValue in
            if newValue != nil {
                locationToEdit = newValue
            }
            print(newValue ?? "none selected.")
        })
        .onChange(of: locationToEdit, { oldValue, newValue in
            if newValue != nil {
                showLocationEditor = true
            }
        })
        .onChange(of: newLocation, { ov, nv in
            print("location creation detected.")
            for location in newLocation {
                print("added new location")
                dataManagerVisit.monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), radius: 100.0, identifier: location.uuid.uuidString)
            }
            
            newLocation = []
            
            /*
            if nv != nil {
                print("added new location")
                dataManagerVisit.monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: newLocation!.latitude, longitude: newLocation!.longitude), radius: 100.0, identifier: newLocation!.uuid.uuidString)
            }
             */
        })
        // location search
        .sheet(isPresented: $showLocationSearch, onDismiss: {
            showLocationSearch = false
        }, content: {
            LocationSearch(show: $showLocationSearch, creation: $newLocation)
        })
        // edit location
        .sheet(isPresented: $showLocationEditor, onDismiss: {
            showLocationEditor = false
            locationToEdit = nil
            mapSelection = nil
        }, content: {
            //LocationEdit(show: $showLocationEditor, showParent: $showDummy, logLocation: locationToEdit!, creationMode: false)
            LocationOverview(show: $showLocationEditor, logLocation: locationToEdit!)
        })
        // visit overview
        .sheet(isPresented: $showVisitOverview, onDismiss: {
            showVisitOverview = false
        }, content: {
            VisitOverview(show: $showVisitOverview)
        })
        .overlay(alignment: .bottomTrailing) {
            VStack {
                if showButtons {
                    /*
                     Button {
                     dataManagerVisit.listRegions()
                     showButtons = false
                     } label: {
                     Image(systemName: "info.circle")
                     .font(.title.weight(.semibold))
                     .padding()
                     .background(Color.gray)
                     .foregroundColor(.white)
                     .clipShape(Circle())
                     .shadow(radius: 4, x: 0, y: 4)
                     }
                     .padding()
                     */
                    Button {
                        showVisitOverview = true
                        showButtons = false
                    } label: {
                        Image(systemName: "list.dash.header.rectangle")
                            .font(.title.weight(.semibold))
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding()
                    
                    Button {
                        addLocation()
                        showButtons = false
                    } label: {
                        Image(systemName: "plus")
                            .font(.title.weight(.semibold))
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding()
                }
                Button {
                    showButtons.toggle()
                } label: {
                    Image(systemName: showButtons ? "arrow.down" : "arrow.up")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                }
                .padding()
            }
        }
    }
    
    init(visitModel: ModelContext) {
        let dataManagerVisit = DataManagerVisit(modelContext: visitModel)
        _dataManagerVisit = State(initialValue: dataManagerVisit)
        //locationManager.delegate = dataManagerVisit
    }
    
    private func addLocation() {
        showLocationSearch = true
    }
    
}

extension ContentView {
    @Observable
    class DataManagerVisit: NSObject, CLLocationManagerDelegate {
        var modelContext: ModelContext
        var locations = [LogLocation]()
        var visits = [LocationVisit]()
        let dataManagerLocationManager = CLLocationManager()
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            super.init()
            dataManagerLocationManager.delegate = self
        }
        
        func addVisit(region: CLRegion) {
            let lv = LocationVisit(locationUUID: UUID(uuidString: region.identifier)!, timeStamp: Date())
            modelContext.insert(lv)
        }
        
        func monitorRegionAtLocation(center: CLLocationCoordinate2D, radius: Double, identifier: String) {
            
            // Make sure the devices supports region monitoring.
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                
                //let maxDistance = CLLocationDistance(exactly: 100)
                // let maxDistance = locationManager.maximumRegionMonitoringDistance
                // For the sake of this tutorial we will use the maxmimum allowed distance.
                // When you are going production, it is recommended to optimize this value according to your needs to be less resource intensive
                
                // Register the region.
                let region = CLCircularRegion(center: center,
                                              radius: radius,
                                              identifier: identifier)
                region.notifyOnEntry = true
                //region.notifyOnExit = true
                
                dataManagerLocationManager.startMonitoring(for: region)
                
                print ("startMonitoring for region: \(region.identifier)")
            } else {
                print ("monitoring not available")
            }
        }
        
        func stopMonitorRegionAtLocation(identifier: UUID) {
            for region in dataManagerLocationManager.monitoredRegions {
                if region.identifier == identifier.uuidString {
                    dataManagerLocationManager.stopMonitoring(for: region)
                }
            }
            
        }
        
        func listRegions() {
            for region in dataManagerLocationManager.monitoredRegions {
                print(region.identifier)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
            print("visited: \(region.identifier)")
            let lv = LocationVisit(locationUUID: UUID(uuidString: region.identifier)!, timeStamp: Date())
            modelContext.insert(lv)
            
            do {
                let descriptor = FetchDescriptor<LogLocation>()
                locations = try modelContext.fetch(descriptor)
            } catch {
                print("fetch failed")
            }
            
            var title = "dummy"
            for location in locations {
                print ("\(location.uuid.uuidString) / \(region.identifier)")
                if location.uuid.uuidString == region.identifier {
                    title = location.title
                }
            }
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = "Haltepunkt erfolgt."
            content.sound = UNNotificationSound.default

            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
        }
    }
}

extension CLLocationCoordinate2D {
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        MKMapPoint(self).distance(to: MKMapPoint(to))
    }
}

/*
#Preview {
    ContentView(modelContainer(for: LogLocation.self, inMemory: false))
        .modelContainer(for: LogLocation.self, inMemory: false)
}
*/
