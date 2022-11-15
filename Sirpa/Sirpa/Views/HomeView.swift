//
//  HomeView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//
import MapKit
import SwiftUI

struct Location: Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct HomeView: View {
    @State var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298),
        span: MKCoordinateSpan(latitudeDelta: 110, longitudeDelta:110)
    )
    @State var locations = [
        Location(name: "Metropolia karamalmi", coordinate: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298)),
        Location(name: "Metropolia myllypuro", coordinate: CLLocationCoordinate2D(latitude: 60.22344, longitude: 25.07795)),
        Location(name: "Metropolia myyrmaki", coordinate: CLLocationCoordinate2D(latitude: 60.25875, longitude: 24.84508))
    ]
    
    var body: some View {
        ZStack{
            /*Map(coordinateRegion: $mapRegion, annotationItems: locations){
                location in MapAnnotation(coordinate: location.coordinate){
                    
                }

            }*/
            MapView(locations: locations)
        }
    }
}
struct MapView: UIViewRepresentable{
    @State var locations:[Location]
    @State var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298),
        span: MKCoordinateSpan(latitudeDelta: 110, longitudeDelta:110)
    )
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.mapType = .hybridFlyover
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        for location in locations {
        
            let pin = MKPointAnnotation()
            
            pin.coordinate = location.coordinate
            
            pin.title = location.name
            
            uiView.addAnnotation(pin)
            
        }
        uiView.setRegion(mapRegion, animated: true)
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
