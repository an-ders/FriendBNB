//
//  HomeTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-03.
//

import SwiftUI
import MapKit

struct AnnotatedItem: Identifiable {
	let id = UUID()
	let name: String
	let coordinate: CLLocationCoordinate2D
}

struct PropertyTileView: View {
    var property: Property
    //var action: () -> Void
	var coordinate: CLLocationCoordinate2D
	
	let decimals = 3
	
	init(property: Property) {
		self.property = property
		self.coordinate = CLLocationCoordinate2D(latitude: property.location.geo.latitude, longitude: property.location.geo.longitude)
	}
    
    var body: some View {
		VStack(spacing: 0) {
			VStack {
				Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
					Marker("", coordinate: coordinate)
				}
				.frame(height: 150)
				.disabled(true)
			}
			.frame(height: 150)
			
			VStack(spacing: 0) {
				if property.nickname.isEmpty {
					Text(property.location.addressTitle)
						.font(.title).fontWeight(.medium)
						.frame(maxWidth: .infinity, alignment: .leading)
					Text(property.location.addressDescription)
						.font(.caption).fontWeight(.light)
						.frame(maxWidth: .infinity, alignment: .leading)
				} else {
					Text(property.nickname)
						.font(.title).fontWeight(.medium)
						.frame(maxWidth: .infinity, alignment: .leading)
					Text(property.location.addressTitle + " " + property.location.addressDescription)
						.font(.caption).fontWeight(.light)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				
			}
			.padding(Constants.Padding.small)
			.foregroundColor(.black.opacity(0.8))
			.background {
				Color.systemGray6
			}
		}
		.clipShape(RoundedRectangle(cornerRadius: 10))
		.padding(.horizontal, Constants.Padding.regular)
			
//		Map(coordinateRegion: $region, annotationItems: [AnnotatedItem(name: property.nickname, coordinate: coordinate)]) { location in
//					MapAnnotation(coordinate: location.coordinate) {
//						Circle()
//							.stroke(.red, lineWidth: 3)
//							.frame(width: 44, height: 44)
//					}
//				}
//        Button(action: {
//            action()
//        }, label: {
//            VStack(alignment: .leading) {
//                Spacer()
//                VStack(spacing: 0) {
//                    Text(property.location.addressTitle)
//                        .font(.title).fontWeight(.medium)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    Text(property.location.addressDescription)
//                        .font(.caption).fontWeight(.light)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                .foregroundColor(.white)
//                .padding(Constants.Padding.small)
//            }
//            .frame(height: 150)
//            .frame(maxWidth: .infinity)
//            .background {
//                RoundedRectangle(cornerRadius: 15)
//                    .foregroundColor(.systemGray2)
//            }
//            .padding(.horizontal, 10)
//        })
    }
}

//struct HomeTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeTileView(property: Property(id: "test123", data: ["title": "testtitle123", "owner": "Anders"]))
//    }
//}
