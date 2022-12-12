//
//  DetailImageView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//

import MapKit
import SwiftUI
import CoreLocationUI
struct DetailImageView: View {
    var data:String
    @State var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.223932, longitude: 24.758298),
        span: MKCoordinateSpan(latitudeDelta: 110, longitudeDelta:110)
    )
    var body: some View {
        Text(data)
        Map(coordinateRegion: $mapRegion, showsUserLocation: true)
                   
        
    }
        
}
