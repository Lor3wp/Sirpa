//
//  MapMarkers.swift
//  Sirpa
//
//  Created by iosdev on 2.12.2022.
//

import Foundation
import CoreLocation
struct MapMarkers: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let file: String
    let notes: String
    let timeStamp: String
    let tripID: String
    let userID: String
}
