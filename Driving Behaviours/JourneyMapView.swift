//
//  JourneyMapView.swift
//  Driving Behaviours
//
//  Created by Reece Nicholls on 03/04/2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    var speedingCoordinates: [[CLLocationCoordinate2D]]?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        
        // Draw the non-speeding coordinates first
        let polylineAll = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        print(lineCoordinates)
        
        
        var allPolylines: [MKPolyline] = []
        allPolylines.append(polylineAll)
        
        // Draw the speeding coordinates on top
        if let speedingList = speedingCoordinates {
            for coordinates in speedingList {
                let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
                allPolylines.append(polyline)
                
                
                // Keep track of which polylines are associated with the speedingCoordinates array
                context.coordinator.speedingPolylines.insert(polyline)
                print("adding speeding polyline \(polyline)")
            }
        }
        
        mapView.addOverlays(allPolylines)
        
        
        // Force the map view to redraw its overlays
        mapView.setNeedsDisplay()
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var speedingPolylines = Set<MKPolyline>()
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                print("Next")
                print(speedingPolylines)
                print(polyline)
                print("End")
                // Set the stroke color based on whether the polyline is in the speedingPolylines set
                if speedingPolylines.contains(polyline) {
                    print("making speeding line red")
                    renderer.strokeColor = .red
                    renderer.lineWidth = 4
                } else {
                    renderer.strokeColor = .green
                    renderer.lineWidth = 4
                }
                
                
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}





struct JourneyMapView: View {
    let journey: DatabaseManager.Journey
    var report: DatabaseManager.JourneyReport?
    var coordinates: [CLLocationCoordinate2D] = []
    var speedingCoordinates: [[CLLocationCoordinate2D]] = []
    
    init(journey: DatabaseManager.Journey, report: DatabaseManager.JourneyReport?) {
        self.journey = journey
        self.report = report
        
        print("Initialising journey map view")
        
        if let events = journey.events {
            for event in events {
                self.coordinates.append(CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude))
            }
        }
        
        if let report = report, let speedingLocations = report.speeding_locations {
            for loc in speedingLocations {
                var arrayOfCoords: [CLLocationCoordinate2D] = []
                
                for event in loc {
                    arrayOfCoords.append(CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude))
                }
                
                self.speedingCoordinates.append(arrayOfCoords)
            }
        }
        
        print("SPEEDING COORDINATES: \(self.speedingCoordinates)")
    }
    
    var body: some View {
        MapView(
            region: MKCoordinateRegion(
                center: coordinates.first ?? CLLocationCoordinate2D(),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ),
            lineCoordinates: coordinates,
            speedingCoordinates: speedingCoordinates
        )
    }
}

//struct JourneyMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        JourneyMapView(journey: DatabaseManager.Journey(journey_id: "1", user_id: "1", time_started: Date.now, time_ended: Date.now+5000, events: [DatabaseManager.JourneyEvent(journey_id: "1", event_id: "1", latitude: 51.5005, longitude: -0.1198, time: Date.now+1, speed: 10, is_speeding: false)]))
//    }
//}
