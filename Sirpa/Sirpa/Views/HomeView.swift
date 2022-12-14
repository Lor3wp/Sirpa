//
//  HomeView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//
import MapKit
import SwiftUI
import CoreLocationUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct Location: Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct AllPostsSheet: View {
    @ObservedObject var model = ViewModel()
    @ObservedObject var timeformatter = TimeFormatter()

    @Environment(\.dismiss) var dismiss
    @State private var notesShown = false

    
    
    var body: some View {
        ZStack {
            
            
            List(model.postList) {
                item in
                ZStack{
                    HStack{
                        if(notesShown == true) {
                            ForEach(model.imageDictionary.filter{
                                $0.key.contains(item.id)
                            }.map {
                                $0.value
                            }
                                    , id: \.self) { item in
                                
                                Image(uiImage: item)
                                    .resizable()
                                    .frame(width: 390, height: 600)
                                    .opacity(0.5)
                                
                            }
                                    .frame(width: 390, height: 600)
                                    .foregroundColor(.white)
                                    .overlay(alignment: .center) {
                                        VStack{
                                            HStack{
                                                VStack{
                                                    
                                                    //PROFILEPIC JA DATE ADDED
                                                    Text("\(timeformatter.formatDate(date: item.timeAdded))")
                                                        .padding()
                                                }
                                            }
                                            Spacer()
                                            HStack {
                                                SmallMap(region: .constant(MKCoordinateRegion(
                                                    center: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude),
                                                    span: MKCoordinateSpan(latitudeDelta: 11, longitudeDelta:11)
                                                )),markersList: [MapMarkers(id: "id", coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), file: "files", notes: "notes", timeStamp: Timestamp(), tripID: "tripID", userID: "userID")])
                                            }
                                            Spacer()
                                            HStack {
                                                //NOTES
                                                Text("\(item.notes)")
                                            } .frame(width: 350)
                                            Spacer()
                                        }
                                    }
                                    .onTapGesture(count: 1) {
                                        notesShown.toggle()
                                    }
                        } else {
                            ForEach(model.imageDictionary.filter{
                                $0.key.contains(item.id)
                            }.map {
                                $0.value
                            }
                                    , id: \.self) { item in
                                
                                Image(uiImage: item)
                                    .resizable()
                                    .frame(width: 390, height: 600)
                                
                            }
                                    .frame(width: 390, height: 600)
                                    .onTapGesture(count: 1) {
                                        notesShown.toggle()
                                    }
                            
                        }
                        
                        
                        
                        
                    }
                }
                
                
                
            }
            
        }.onAppear {
            model.retreiveAllPostPhotos()
            model.getPosts()
        
    }
    }
    
}



struct HomeView: View {
    
    @State private var isVisible = false
    
    @StateObject var locationManager = LocationManager()
    @ObservedObject var model = ViewModel()

    @State var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298),
        span: MKCoordinateSpan(latitudeDelta: 110, longitudeDelta:110)
    )
    @State var locations=[
        MapMarkers(id: "1", coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 20), file: "file", notes: "notes", timeStamp: Timestamp(), tripID: "trip", userID: "user")
    ]
    

    var body: some View {
        ZStack{
            //            Map(coordinateRegion: $locationManager.region, interactionModes: [.all], showsUserLocation: true)
            //            .onAppear(){
            //                MKMapView.appearance().mapType = .hybridFlyover
            //                MKMapView.appearance().pointOfInterestFilter = .excludingAll
            //            }

            AreaMap(region: $locationManager.region, markersList: $model.mapMarkers)
                .onAppear{
                    MKMapView.appearance().mapType = .satelliteFlyover
                    MKMapView.appearance().pointOfInterestFilter = .excludingAll
                }
            
            //            MapView(locations: locations, lManager: $locationManager.region)
            VStack{
                Spacer()
                HStack{
                    Button(action: {
                        let loc = model.mapMarkers.randomElement()
                        locationManager.randomPinn(pinn: loc ?? MapMarkers(id: "none",
                                                                           coordinate: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298),
                                                                           file: "none",
                                                                           notes: "none",
                                                                           timeStamp: Timestamp(),
                                                                           tripID: "none",
                                                                           userID: "none"))
                    }) {
                        Image(systemName: "dice")
                            .foregroundColor(.white)
                            .font(.system(size:20))
                    }
                    .frame(width: 45, height: 45)
                    .background(.blue)
                    .cornerRadius(100)
                    .padding(.trailing, 30)
                    
                    
                    Button("See all posts") {
                        isVisible.toggle()
                    }.frame(width: 180, height: 40)
                        .background(.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .sheet(isPresented: $isVisible) {
                            AllPostsSheet()
                        }
                    LocationButton(){
                        locationManager.requestLocation()
                    }
                        .symbolVariant(.fill)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .labelStyle(.iconOnly)
                        .padding(.leading, 30)
//                        .frame(width: 50, height: 50)

           
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear{
            MKMapView.appearance().mapType = .satelliteFlyover
            MKMapView.appearance().pointOfInterestFilter = .excludingAll
        }
    }
    init(){
        model.getPosts()
    }
        
}

struct AreaMap: View {
    @Binding var region: MKCoordinateRegion
    @Binding var markersList: [MapMarkers]
    var body: some View {
        let binding = Binding(
            get: { self.region },
            set: { newValue in
                DispatchQueue.main.async {
                    self.region = newValue
                }
            }
        )

        return Map(coordinateRegion: binding, showsUserLocation: true, annotationItems: markersList, annotationContent: {item in
            MapMarker(coordinate: item.coordinate)
        })

    }
}
struct SmallMap: View {
    @Binding var region: MKCoordinateRegion
     var markersList: [MapMarkers]
    var body: some View {
        let binding = Binding(
            get: { self.region },
            set: { newValue in
                DispatchQueue.main.async {
                    self.region = newValue
                }
            }
        )

        return Map(coordinateRegion: binding, interactionModes:[], annotationItems: markersList, annotationContent: {item in
            MapMarker(coordinate: item.coordinate)
                
                
//            MapAnnotation(coordinate:item.coordinate){
//                Circle()
//            }
//            DispatchQueue.main.async{
//                MapAnnotation(coordinate:item.coordinate){
//                    Circle()
//                }
//            }
                
        })
        .frame(width: 200, height: 200)
        .cornerRadius(100)
        .onAppear(){
            MKMapView.appearance().mapType = .hybrid
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
