//
//  OwnedExistingBookingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct OwnedExistingBookingView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var bookingStore: BookingStore
	@Environment(\.dismiss) private var dismiss
	
	@State var bookingDetail: Booking?

	var body: some View {
		if let property = propertyStore.selectedOwnedProperty {
			if property.bookings.current().isEmpty {
				emptyView
			} else {
				NavigationStack {
					PairButtonWrapper(prevText: "", prevAction: {
						
					}, nextText: "Back", nextAction: {
						dismiss()
					}, content: {
						VStack {
							Text("Bookings")
								.font(.largeTitle).fontWeight(.medium)
								.frame(maxWidth: .infinity, alignment: .leading)
								.padding(.bottom, Constants.Spacing.small)
							
							ScrollView {
								VStack {
									ForEach(property.bookings.current().dateSorted()) { booking in
										Button(action: {
											bookingDetail = booking
										}, label: {
											BookingTileView(booking: booking, showName: true)
										})
									}
									
									PairButtonSpacer()
								}
							}
						}
					})
					.interactiveDismissDisabled()
					.padding(.horizontal, Constants.Padding.regular)
					.padding(.top, Constants.Padding.small)
					.navigationDestination(item: $bookingDetail) { booking in
						OwnerBookingConfirmationView(property: property, booking: booking)
					}
				}
			}
		} else {
			NoSelectedPropertyView()
		}
	}
	
	var emptyView: some View {
		VStack {
			Image(systemName: "house")
				.resizable()
				.scaledToFit()
				.frame(width: 50)
			Text("It's empty in here.")
				.font(.title).fontWeight(.medium)
			Text("No bookings for this property")
				.font(.headline).fontWeight(.light)
				.padding(.bottom, 8)
			
			Button(action: {
				Task {
					dismiss()
				}
			}, label: {
				Text("Close")
					.font(.headline)
					.padding(.horizontal, 16)
					.padding(.vertical, 8)
					.foregroundColor(.white)
					.background(Color.systemGray3)
					.cornerRadius(10)
			})
		}
	}
}

//extension OwnedExistingBookingView {
//	class ViewModel: ObservableObject {
//		@Published var property: Property
//		
//		func subscribe() {
//			print("Adding listener in BOOKING MANAGER")
//			
//			let db = Firestore.firestore()
//			self.listener = db.collection("Properties").document(property.id)
//				.addSnapshotListener { documentSnapshot, error in
//					guard let document = documentSnapshot else {
//						print("Error fetching document: \(error!)")
//						return
//					}
//					
//					if let newData = document.data() {
//						print("Updating data BOOKING MANAGER")
//						self.property = Property(id: self.property.id, data: newData)
//					} else {
//					}
//				}
//		}
//		
//		func unsubscribe() {
//			print("Removing listener from BOOKING MANAGER")
//			self.listener?.remove()
//		}
//	}
//}

//#Preview {
//	OwnedExistingBookingView()
//}
