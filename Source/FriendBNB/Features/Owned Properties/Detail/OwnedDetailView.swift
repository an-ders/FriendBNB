//
//  PropertyDetail.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore

struct OwnedDetailView: View {
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var notificationStore: NotificationStore
	
	@State var confirmDelete = false
	
	var body: some View {
		if let property = propertyStore.selectedOwnedProperty {
			VStack {
				ScrollView(showsIndicators: false) {
					VStack(spacing: Constants.Padding.regular) {
						VStack {
							Text(property.location.addressTitle)
								.font(.title).fontWeight(.medium)
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(property.location.addressDescription)
								.font(.headline).fontWeight(.light)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
						
						TabView {
							Image(systemName: "house")
								.resizable()
								.scaledToFill()
								.background(Color.systemGray5)
							Image(systemName: "house")
								.resizable()
								.scaledToFill()
								.background(Color.systemGray5)
						}
						.frame(height: 250)
						.cornerRadius(20)
						.tabViewStyle(.page(indexDisplayMode: .always))
						.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
						
						HStack {
							Button(action: {
								propertyStore.showOwnedBooking.toggle()
							}, label: {
								VStack {
									Image(systemName: "calendar.badge.clock")
										.resizable()
										.scaledToFit()
										.frame(width: 40)
									Text("Bookings")
										.font(.headline).fontWeight(.medium)
								}
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.foregroundStyle(Color.white)
								.background(Color.systemBlue.opacity(0.6))
								.cornerRadius(5)
							})
							
							Button(action: {
								propertyStore.showOwnedAvailability.toggle()
							}, label: {
								VStack {
									Image(systemName: "calendar.badge.plus")
										.resizable()
										.scaledToFit()
										.frame(width: 40)
									Text("Availability")
										.font(.headline).fontWeight(.medium)
									
								}
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.foregroundStyle(Color.white)
								.background(Color.systemBlue.opacity(0.6))
								.cornerRadius(5)
							})
						}
						.frame(height: 100)
						
						HStack {
							Image(systemName: "person.2.fill")
								.resizable()
								.scaledToFit()
								.frame(width: 25)
							Text("Max number of people: ")
								.body()
							Text(String(property.people))
								.font(.headline).fontWeight(.semibold)
							Spacer()
						}
						VStack {
							HStack {
								Image(systemName: "dollarsign.circle.fill")
									.resizable()
									.scaledToFit()
									.frame(width: 25)
								Text("Cost per night: ")
									.body()
								Text(property.payment == .free ? "FREE" : "\(property.cost) \(property.payment.rawValue)")
									.font(.headline).fontWeight(.semibold)
								Spacer()
							}
							Text(property.paymentNotes.isEmpty ? "" : property.paymentNotes)
								.body()
								.fillLeading()
						}
						
						if !property.notes.isEmpty {
							VStack {
								Text("Notes")
									.heading()
									.fillLeading()
								
								Text(property.notes)
									.body()
									.fillLeading()
							}
						}
						
						if !property.cleaningNotes.isEmpty {
							VStack {
								Text("Cleaning Notes")
									.heading()
									.fillLeading()
								
								Text(property.cleaningNotes)
									.body()
									.fillLeading()
							}
						}
						
						if !property.wifi.isEmpty {
							VStack {
								Text("Wifi")
									.heading()
									.fillLeading()
								
								Text(property.wifi)
									.body()
									.fillLeading()
							}
						}
						
						if !property.securityCode.isEmpty {
							VStack {
								Text("Security Code")
									.heading()
									.fillLeading()
								
								Text(property.securityCode)
									.body()
									.fillLeading()
							}
						}
						if !property.contactInfo.isEmpty {
							VStack {
								Text("Contact Info")
									.heading()
									.fillLeading()
								
								Text(property.contactInfo)
									.body()
									.fillLeading()
							}
						}
						
						Rectangle()
							.frame(height: 40)
							.foregroundStyle(Color.clear)
					}
				}
				
				Button(action: {
					if property.available.current().isEmpty {
						notificationStore.pushNotification(message: "Please set availability")
					} else {
						
					}
				}, label: {
					HStack {
						Image(systemName: "square.and.arrow.up")
							.resizable()
							.scaledToFit()
							.frame(width: 20)
						Text("Share")
					}
					.padding(.vertical, Constants.Padding.small)
					.frame(maxWidth: .infinity)
					.foregroundStyle(Color.white)
					.background(property.available.current().isEmpty ? Color.systemGray3 : Color.systemBlue.opacity(0.6))
					.cornerRadius(5)
				})
			}
			.padding(.horizontal, Constants.Padding.regular)
			.toolbar(.hidden, for: .bottomBar)
			.toolbar(.hidden, for: .tabBar)
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					OwnedDetailSettingsView(confirmDelete: $confirmDelete) {
						let pasteboard = UIPasteboard.general
						pasteboard.string = "Open the FriendBNB and add my property: \(property.id)"
						
						notificationStore.pushNotification(message: "Share message copied to clipboard")
					}
				}
			}
			.alert(isPresented: $confirmDelete) {
				Alert(title: Text("Are you sure you want to delete this property?"),
					  primaryButton: .destructive(Text("Delete")) {
					Task {
						await propertyStore.deleteProperty(id: property.id, type: .owned)
					}
				},
					  secondaryButton: .default(Text("Cancel")))
			}
			.sheet(isPresented: $propertyStore.showOwnedAvailability) {
				OwnedAvailabilityView(property: property)
					.interactiveDismissDisabled()
			}
			.sheet(isPresented: $propertyStore.showOwnedBooking) {
				OwnedExistingBookingView(property: property)
					.interactiveDismissDisabled()
			}
			.onAppear {
				propertyStore.subscribe()
			}
			.onDisappear {
				propertyStore.unsubscribe()
			}
		} else {
			NoSelectedPropertyView()
		}
	}
}

extension OwnedDetailView {
	@MainActor
	class ViewModel: ObservableObject {
		//@Published var property: Property
	}
}

//struct PropertyDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PropertyDetail()
//    }
//}
