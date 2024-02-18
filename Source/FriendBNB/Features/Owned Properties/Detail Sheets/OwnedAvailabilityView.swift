//
//  OwnedAvailabilityView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-14.
//

import SwiftUI

struct OwnedAvailabilityView: View {
	@EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var propertyStore: PropertyStore
	@Environment(\.dismiss) private var dismiss
	
	@StateObject var calendarViewModel: CalendarViewModel
	init(property: Property) {
		self._calendarViewModel = StateObject(wrappedValue: CalendarViewModel(property: property))
	}
	
	var body: some View {
		VStack {
			VStack {
				HStack(alignment: .center) {
					Text("Set Availability")
						.title()
						.fillLeading()
						.padding(.bottom, Constants.Spacing.small)
					
					Button(action: {
						dismiss()
					}, label: {
						Text("Done")
							.font(.headline).fontWeight(.semibold)
							.underline()
					})
				}
				
				CalendarView(type: .owned)
					.environmentObject(calendarViewModel)
					.padding(.horizontal, Constants.Padding.regular)
					.frame(maxHeight: 300)
				
				Text(calendarViewModel.error)
					.font(.headline).fontWeight(.light)
					.frame(maxWidth: .infinity, alignment: .leading)
					.foregroundColor(Color.systemRed)
				
				HStack {
					Spacer()
					Button(action: {
						calendarViewModel.isAvailableMode = true
					}, label: {
						Text("Available")
							.body()
							.padding(.horizontal, 20)
							.padding(.vertical, 8)
							.foregroundStyle(Color.black)
							.background(calendarViewModel.isAvailableMode ? Color.systemGreen.opacity(0.6) : Color.systemGray3)
							.cornerRadius(20)
					})
					Spacer()
					Button(action: {
						calendarViewModel.isAvailableMode = false
					}, label: {
						Text("Unavailable")
							.body()
							.padding(.horizontal, 20)
							.padding(.vertical, 8)
							.foregroundStyle(Color.black)
							.background(!calendarViewModel.isAvailableMode ? Color.systemRed.opacity(0.6) : Color.systemGray4)
							.cornerRadius(20)
					})
					Spacer()
				}
				
				ScrollView(showsIndicators: false) {
					VStack {
						if calendarViewModel.isAvailableMode {
							ForEach(calendarViewModel.property.available.current().dateSorted()) { availability in
								AvailabilityTileView(availibility: availability, type: .available, bgColor: Color.systemGray3) {
									Task {
										await bookingStore.deleteBooking(availability, type: .available, property: calendarViewModel.property)
									}
								}
							}
						} else {
							ForEach(calendarViewModel.property.unavailable.current().dateSorted()) { availability in
								AvailabilityTileView(availibility: availability, type: .unavailable, bgColor: .systemGray) {
									Task {
										await bookingStore.deleteBooking(availability, type: .unavailable, property: calendarViewModel.property)
									}
								}
							}
						}
						
						Rectangle()
							.fill(
								.white
							)
							.frame(maxWidth: .infinity)
							.frame(height: 70)
					}
				}
			}
			
			HStack {
				if let start = calendarViewModel.startDate, let end = calendarViewModel.endDate {
					Text(start.formattedDate())
						.bodyBold()
						.frame(maxWidth: .infinity, alignment: .center)
					Image(systemName: "arrow.right")
						.resizable()
						.scaledToFit()
						.frame(width: 15)
					Text(end.formattedDate())
						.bodyBold()
						.frame(maxWidth: .infinity, alignment: .center)
					doneButton
				} else if let date = calendarViewModel.startDate {
					Text(date.formattedDate())
						.bodyBold()
						.frame(maxWidth: .infinity, alignment: .center)
					doneButton
				} else if let date = calendarViewModel.endDate {
					Text(date.formattedDate())
						.bodyBold()
						.frame(maxWidth: .infinity, alignment: .center)
					doneButton
				} else {
					doneButton
				}
			}
		}
		.padding(.horizontal, Constants.Padding.regular)
		.padding(.top, Constants.Padding.small)
		.onTapGesture {
			calendarViewModel.resetDates()
		}
		.onAppear {
			calendarViewModel.subscribe()
		}
		.onDisappear {
			calendarViewModel.unsubscribe()
		}
	}
	
	var doneButton: some View {
		Button(action: {
			if (calendarViewModel.startDate != nil || calendarViewModel.endDate != nil) {
				Task {
					if let error = await bookingStore.addSchedule(
						startDate: calendarViewModel.startDate,
						endDate: calendarViewModel.endDate,
						property: calendarViewModel.property,
						type: calendarViewModel.isAvailableMode ? .available : .unavailable) {
						calendarViewModel.error = error
					} else {
						calendarViewModel.resetDates()
					}
				}
			} else {
				propertyStore.showOwnedAvailability.toggle()
			}
		}, label: {
			Text(calendarViewModel.startDate != nil || calendarViewModel.endDate != nil ? "Set" : "Done")
				.font(.headline).fontWeight(.semibold)
				.frame(maxWidth: .infinity)
				.padding(.vertical, 12)
				.foregroundColor(.white)
				.background((calendarViewModel.startDate != nil && calendarViewModel.endDate != nil) || (calendarViewModel.startDate == nil && calendarViewModel.endDate == nil) ? Color.systemBlue.opacity(0.6) : Color.systemGray3)
				.cornerRadius(5)
		})
	}
}

//struct BookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingView()
//    }
//}
