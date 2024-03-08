//
//  FriendDetailView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import MapKit

struct FriendDetailView: View {
    @EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var notificationStore: NotificationStore
	
	@Environment(\.dismiss) private var dismiss
	@Environment(\.safeAreaInsets) private var safeAreaInsets
	
	@State var deleteProperty = false
	@State var deleteBooking = false
	@State var showAddToCalendar: PropertyBookingGroup?

    var body: some View {
		if let property = propertyStore.friendSelectedProperty {
			VStack(spacing: 0) {
				ScrollView(showsIndicators: false) {
					VStack(spacing: Constants.Spacing.large) {
						// NAV BAR
						navBar

						// BODY
						bodyContent
					}
				}
				.ignoresSafeArea(.container)
				
				// CTA
				VStack(spacing: 0) {
					Divider()
					
					Button(action: {
						propertyStore.showFriendNewBookingSheet.toggle()
					}, label: {
						HStack {
							Image(systemName: "calendar.badge.plus")
								.resizable()
								.scaledToFit()
								.frame(height: 30)
							Text("New Booking")
								.font(.headline).fontWeight(.medium)
							
						}
						.padding(.vertical, Constants.Spacing.small)
						.frame(maxWidth: .infinity)
						.foregroundStyle(Color.white)
						.background(Color.systemBlue.opacity(0.6))
						.cornerRadius(5)
					})
					.padding(Constants.Spacing.regular)
				}
			}
			.toolbar(.hidden, for: .navigationBar)
			.navigationTitle(property.info.nickname)
			.alert(isPresented: $deleteProperty) {
				Alert(title: Text("Are you sure you want to remove this property?"),
					  primaryButton: .destructive(Text("Remove")) {
					Task {
						await propertyStore.removePropertyFromUser(property.id, type: .friend)
						dismiss()
					}
				},
					  secondaryButton: .default(Text("Cancel")))
			}
			.sheet(item: $propertyStore.friendSelectedBookingInDetail) { booking in
				BookingConfirmationView(property: property, booking: booking) {
					PairButtonsView(prevText: "Delete", prevAction: {
						deleteBooking.toggle()
					}, nextText: "Done", nextCaption: "", nextAction: {
						propertyStore.friendSelectedBookingInDetail = nil
					})
					.padding(.horizontal, Constants.Spacing.regular)
				}
				.alert(isPresented: $deleteBooking) {
					Alert(title: Text("Are you sure you want to delete this booking?"),
						  primaryButton: .destructive(Text("Delete")) {
						Task {
							await bookingStore.deleteBooking(booking, propertyId: property.id)
							propertyStore.friendSelectedBookingInDetail = nil
							await propertyStore.fetchProperties(.friend)
						}
					},
						  secondaryButton: .default(Text("Cancel")))
				}
			}
			.sheet(isPresented: $propertyStore.showFriendNewBookingSheet) {
				FriendNewBookingView(property: property)
					.interactiveDismissDisabled()
			}
			.sheet(item: $showAddToCalendar) { group in
				EventEditViewController(group: group) {
					showAddToCalendar = nil
				}
			}
			.onAppear {
				propertyStore.subscribe(type: .friend)
			}
			.onDisappear {
				propertyStore.unsubscribe()
			}
		} else {
			NoSelectedPropertyView()
		}
    }
	
	var navBar: some View {
		ZStack {
			let property = propertyStore.friendSelectedProperty!
			let coordinate = CLLocationCoordinate2D(latitude: property.location.geo.latitude, longitude: property.location.geo.longitude)
			let center =  CLLocationCoordinate2D(latitude: property.location.geo.latitude, longitude: property.location.geo.longitude)
			Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)))) {
				Marker("", coordinate: coordinate)
			}
			.disabled(true)
			
			VStack(spacing: 0) {
				HStack {
					Button(action: {
						dismiss()
					}, label: {
						VStack {
							Image(systemName: "arrow.left")
								.size(width: 20, height: 20)
								.foregroundStyle(.white)
						}
						.padding(10)
						.darkWindow()
						.cornerRadius(5)
					})
					
					Spacer()
					
					Menu(content: {
						Button(role: .destructive, action: {
							deleteProperty = true
						}, label: {
							Label("Remove", systemImage: "trash")
						})
					}, label: {
						VStack {
							Image(systemName: "ellipsis")
								.size(width: 20, height: 20)
								.foregroundStyle(.white)
						}
						.padding(10)
						.darkWindow()
						.cornerRadius(5)
					})
				}
				.zIndex(4)
				.padding(.top, safeAreaInsets.top + 10)
				
				Spacer()
				
				VStack(alignment: .center, spacing: 0) {
					Text(property.info.nickname)
						.styled(.title, weight: .bold)
						.foregroundStyle(.white)
					Text("People: \(property.info.people) | Cost: \(property.info.payment == .free ? "Free" : "$" + String(format: "%.2f", property.info.cost))")
						.styled(.caption)
						.foregroundStyle(Color.systemGray5)
				}
				.padding(Constants.Spacing.medium)
				.darkWindow()
				.cornerRadius(5)
				.padding(.bottom, 20)
			}
			.padding(Constants.Spacing.large)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.foregroundStyle(Color.white)
			.background(Color.black.opacity(0.4))
		}
		.frame(height: 350)
	}
	
	var bodyContent: some View {
		VStack(spacing: 50) {
			let property = propertyStore.friendSelectedProperty!
			
			PropertyDetailList(property: property)
			
			let bookings = property.bookings.withId(id: Auth.auth().currentUser!.uid).current().dateSorted()
			if !bookings.isEmpty {
				VStack(spacing: 0) {
					Text("YOUR BOOKINGS")
						.styled(.bodyBold)
						.fillLeading()
						.foregroundStyle(Color.systemGray)
					
					List {
						ForEach(bookings, id: \.id) { booking in
							Button(action: {
								propertyStore.friendSelectedBookingInDetail = booking
							}, label: {
								BookingTileView(booking: booking, showName: false) {
									if booking.status == .confirmed {
										Button(action: {
											showAddToCalendar = PropertyBookingGroup(type: .friend, property: property, booking: booking)
										}, label: {
											Image(systemName: "calendar")
												.resizable()
												.scaledToFit()
												.frame(height: 20)
										})
									}
								}
							})
						}
					}
					.listStyle(.plain)
					.environment(\.defaultMinListRowHeight, 90)
					.frame(height: 90 * CGFloat(bookings.count))
					.padding(.horizontal, -Constants.Spacing.regular)
				}
			}
		}
		.padding(.horizontal, Constants.Spacing.regular)
		.padding(.top, 20)
		.padding(.bottom, 50)
	}
}
//struct PropertyDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PropertyDetail()
//    }
//}
