//
//  Location.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-08.
//

import Foundation
import MapKit

struct Location {
    var streetNumber: String
    var streetName: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    
    var formattedAddress: String {
        return """
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
    }
    
    var addressTitle: String {
        return """
        \(streetNumber) \(streetName)
        """
    }
    
    var addressDescription: String {
        return """
        \(city), \(state) \(zipCode) \(country)
        """
    }
    
    var dictonary: [String: Any] {
        [
            "streetNumber": streetNumber,
            "streetName": streetName,
            "city": city,
            "state": state,
            "zipCode": zipCode,
            "country": country
        ]
    }
    
    init(placemark: MKPlacemark) {
        self.streetName = placemark.thoroughfare ?? ""
        self.streetNumber = placemark.subThoroughfare ?? ""
        self.city = placemark.locality ?? ""
        self.state = placemark.administrativeArea ?? ""
        self.zipCode = placemark.postalCode ?? ""
        self.country = placemark.country ?? ""
    }
    
    init(data: [String: Any]) {
        self.streetName = data["streetName"] as? String ?? ""
        self.streetNumber = data["streetNumber"] as? String ?? ""
        self.city = data["city"] as? String ?? ""
        self.state = data["state"] as? String ?? ""
        self.zipCode = data["zipCode"] as? String ?? ""
        self.country = data["country"] as? String ?? ""
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
