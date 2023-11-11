//
//  Location.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-08.
//

import Foundation
import MapKit

struct Location {
    let streetNumber: String    // eg. 1
    let streetName: String      // eg. Infinite Loop
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    
    var formattedAddress: String {
        return """
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
    }
    
    var dictonary: [String: Any] {
        [
            "streetNumber": streetNumber,
            "streetName": streetName,
            "city": city,
            "state": state,
            "zipCode": zipCode,
            "country": country,
        ]
    }
    
    init(with placemark: MKPlacemark) {
        self.streetName = placemark.thoroughfare ?? ""
        self.streetNumber = placemark.subThoroughfare ?? ""
        self.city = placemark.locality ?? ""
        self.state = placemark.administrativeArea ?? ""
        self.zipCode = placemark.postalCode ?? ""
        self.country = placemark.country ?? ""
    }
    
    init() {
        self.streetName = ""
        self.streetNumber = ""
        self.city = ""
        self.state = ""
        self.zipCode = ""
        self.country = ""
    }
}
