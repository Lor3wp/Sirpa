//
//  HomeView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//
import MapKit
import SwiftUI
import CoreLocationUI

struct Location: Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}


struct HomeView: View {
    
    @StateObject var locationManager = LocationManager()

    @State var locations = [
        Location(name: "Metropolia karamalmi", coordinate: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298)),
        Location(name: "Metropolia myllypuro", coordinate: CLLocationCoordinate2D(latitude: 60.22344, longitude: 25.07795)),
        Location(name: "Metropolia myyrmaki", coordinate: CLLocationCoordinate2D(latitude: 60.25875, longitude: 24.84508)),
        Location(name: "MArk 1", coordinate: CLLocationCoordinate2D(latitude: 37.78869, longitude: -122.40538)),
        Location(name: "Mark 2", coordinate: CLLocationCoordinate2D(latitude: 37.791771, longitude: -122.39705)),
        Location(name: "Mark 3", coordinate: CLLocationCoordinate2D(latitude: 37.78257, longitude: -122.39646))
    ]
    func PinLocation(){
        
    }
    var body: some View {
        ZStack{
            /*Map(coordinateRegion: $mapRegion, annotationItems: locations){
                location in MapAnnotation(coordinate: location.coordinate){
                    
                }

            }*/
            MapView(locations: locations, lManager: $locationManager.region)
            
            
            VStack{
                if let location = locationManager.location{
                    Text("**Current location:**\(location.latitude),\(location.longitude)")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                }
                Spacer()
                LocationButton{
                    locationManager.requestLocation()
                }
                .frame(width: 180, height: 40)
                .cornerRadius(30)
                .symbolVariant(.fill)
                .foregroundColor(.white)
            }
            .padding()
        }
    }
}
struct MapView: UIViewRepresentable{
    @State var locations:[Location]
    @Binding var lManager:MKCoordinateRegion

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
        uiView.setRegion(lManager, animated: true)
        uiView.showsUserLocation = true
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
