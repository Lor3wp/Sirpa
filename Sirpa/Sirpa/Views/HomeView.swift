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
    
    @State var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298),
        span: MKCoordinateSpan(latitudeDelta: 110, longitudeDelta:110)
    )
    
    @State var locations = [
        Location(name: "Metropolia karamalmi", coordinate: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298)),
        Location(name: "Metropolia myllypuro", coordinate: CLLocationCoordinate2D(latitude: 60.22344, longitude: 25.07795)),
        Location(name: "Metropolia myyrmaki", coordinate: CLLocationCoordinate2D(latitude: 60.25875, longitude: 24.84508)),
        Location(name: "MArk 1", coordinate: CLLocationCoordinate2D(latitude: 37.78869, longitude: -122.40538)),
        Location(name: "Mark 2", coordinate: CLLocationCoordinate2D(latitude: 37.791771, longitude: -122.39705)),
        Location(name: "Mark 3", coordinate: CLLocationCoordinate2D(latitude: 37.78257, longitude: -122.39646))
    ]

    var body: some View {
        ZStack{
            Map(coordinateRegion: $locationManager.region, interactionModes: [.all], showsUserLocation: true, annotationItems: locations){item in AnyMapAnnotationProtocol(MapAnnotation(coordinate: item.coordinate){
                NavigationLink(destination: DetailImageView(data: "\(item.coordinate)")){
                    HStack{
                        Image(systemName: "pin.fill")
                            .resizable()
                            .frame(width: 35, height: 30)
                            .clipShape(Capsule())
                            .foregroundColor(Color(.systemRed))

                    }
                }
                .buttonStyle(PlainButtonStyle())
                
            })}
            .onAppear{
                MKMapView.appearance().mapType = .hybridFlyover
                MKMapView.appearance().pointOfInterestFilter = .excludingAll
            }
            
            //MapView(locations: locations, lManager: $locationManager.region)
            
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

struct AnyMapAnnotationProtocol: MapAnnotationProtocol{
    var _annotationData: _MapAnnotationData
        let value:Any
    
    init<WrappedType:MapAnnotationProtocol>(_ value:WrappedType){
        self.value=value
        _annotationData = value._annotationData
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
