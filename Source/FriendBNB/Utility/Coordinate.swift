//
//  Coordinate.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-26.
//

import Foundation
import MapKit

func locationWithBearing(bearing: Double, distanceMeters: Double, origin: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
	let distRadians = distanceMeters / (6372797.6)

	let rbearing = bearing * .pi / 180.0

	let lat1 = origin.latitude * .pi / 180
	let lon1 = origin.longitude * .pi / 180

	let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(rbearing))
	let lon2 = lon1 + atan2(sin(rbearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
	return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
}
