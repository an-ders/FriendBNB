//
//  Location.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-08.
//

import Foundation
import MapKit
import FirebaseFirestore

protocol PropertyLocation {
	var streetNumber: String { get set }
	var streetName: String { get set }
	var city: String { get set }
	var state: String { get set }
	var zipCode: String { get set }
	var country: String { get set }
	var geo: GeoPoint { get set }
}

class Location: PropertyLocation, ObservableObject, Equatable {
	@Published var streetNumber: String = ""
	@Published var streetName: String = ""
	@Published var city: String = ""
	@Published var state: String = ""
	@Published var zipCode: String = ""
	@Published var country: String = ""
	@Published var geo: GeoPoint = GeoPoint(latitude: 0, longitude: 0)
	
	@Published var error: String = ""
	
	var formattedAddress: String {
		return "\(streetNumber) \(streetName) \(city), \(state) \(zipCode) \(country)"
	}
	
	var addressTitle: String {
		return "\(streetNumber) \(streetName)"
	}
	
	var addressDescription: String {
		return "\(city), \(state) \(zipCode) \(country)"
	}
	
	var dictonary: [String: Any] {
		["location": [
			"streetNumber": streetNumber,
			"streetName": streetName,
			"city": city,
			"state": state,
			"zipCode": zipCode,
			"country": country,
			"geo": geo
			]
		]
	}
		
	init(placemark: MKPlacemark) {
		self.streetName = placemark.thoroughfare ?? ""
		self.streetNumber = placemark.subThoroughfare ?? ""
		self.city = placemark.locality ?? ""
		self.state = placemark.administrativeArea ?? ""
		self.zipCode = placemark.postalCode ?? ""
		self.country = placemark.country ?? ""
		self.geo = 	GeoPoint.init(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
		self.error = ""
	}
	
	init(data: [String: Any]) {
		self.streetName = data["streetName"] as? String ?? ""
		self.streetNumber = data["streetNumber"] as? String ?? ""
		self.city = data["city"] as? String ?? ""
		self.state = data["state"] as? String ?? ""
		self.zipCode = data["zipCode"] as? String ?? ""
		self.country = data["country"] as? String ?? ""
		self.geo = data["geo"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
		self.error = ""
	}
	
	init() {}
	
	func checkAddress() -> Bool {
		let emptyError = "Field cannot be empty."
		
		if streetName.isEmpty || streetNumber.isEmpty || city.isEmpty || state.isEmpty  || zipCode.isEmpty || country.isEmpty {
			self.error = emptyError
			return false
		}
		
		return true
	}
	
	func update(placemark: MKPlacemark) {
		self.streetName = placemark.thoroughfare ?? ""
		self.streetNumber = placemark.subThoroughfare ?? ""
		self.city = placemark.locality ?? ""
		self.state = placemark.administrativeArea ?? ""
		self.zipCode = placemark.postalCode ?? ""
		self.country = placemark.country ?? ""
		self.geo = GeoPoint.init(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
		self.error = ""
	}
	
	func update(data: [String: Any]) {
		self.streetName = data["streetName"] as? String ?? ""
		self.streetNumber = data["streetNumber"] as? String ?? ""
		self.city = data["city"] as? String ?? ""
		self.state = data["state"] as? String ?? ""
		self.zipCode = data["zipCode"] as? String ?? ""
		self.country = data["country"] as? String ?? ""
		self.geo = data["geo"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
		self.error = ""
	}
	
	static func == (lhs: Location, rhs: Location) -> Bool {
		lhs.streetName == rhs.streetName && lhs.streetNumber == rhs.streetNumber && lhs.city == rhs.city && lhs.state == rhs.state && lhs.zipCode == rhs.zipCode && lhs.country == rhs.country
	}
}
