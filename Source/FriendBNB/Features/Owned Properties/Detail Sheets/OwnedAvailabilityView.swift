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
			ScrollView(showsIndicators: false) {
				VStack {
					DetailSheetTitle(title: "Set Availability")
					
					Text(calendarViewModel.mode == .available ? "Select the days that are available:" : "Select the days that are unavailable:")
						.styled(.body)
						.fillLeading()
					
					CalendarView(type: .owned)
						.environmentObject(calendarViewModel)
						.padding(.horizontal, Constants.Spacing.regular)
						.frame(maxHeight: 300)
					
					Text(calendarViewModel.error)
						.font(.headline).fontWeight(.light)
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundColor(Color.systemRed)
					
					HStack {
						Spacer()
						Button(action: {
							calendarViewModel.mode = .available
						}, label: {
							Text("Available")
								.styled(.bodyBold)
								.padding(.horizontal, 20)
								.padding(.vertical, 8)
								.foregroundStyle(Color.black)
								.background(calendarViewModel.mode == .available ? calendarViewModel.mode.colorBG : Color.systemGray6)
								.cornerRadius(20)
						})
						Spacer()
						Button(action: {
							calendarViewModel.mode = .unavailable
						}, label: {
							Text("Unavailable")
								.styled(.bodyBold)
								.padding(.horizontal, 20)
								.padding(.vertical, 8)
								.foregroundStyle(Color.black)
								.background(calendarViewModel.mode == .unavailable ? calendarViewModel.mode.colorBG : Color.systemGray6)
								.cornerRadius(20)
						})
						Spacer()
					}
					
					VStack {
						if calendarViewModel.mode == .available {
							availableList
							unavailableList
						} else {
							unavailableList
							availableList

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
				if let start = calendarViewModel.startDate {
					Text(start.dayMonthString())
						.styled(.bodyBold)
						.frame(maxWidth: .infinity, alignment: .center)
				}
				if let end = calendarViewModel.endDate {
					Image(systemName: "arrow.right")
						.resizable()
						.scaledToFit()
						.frame(width: 15)
					Text(end.dayMonthString())
						.styled(.bodyBold)
						.frame(maxWidth: .infinity, alignment: .center)
				}
				doneButton
			}
		}
		.padding(.horizontal, Constants.Spacing.regular)
		.padding(.top, Constants.Spacing.small)
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
	
	var unavailableList: some View {
		ForEach(calendarViewModel.property.unavailable.current().dateSorted()) { availability in
			AvailabilityTileView(availibility: availability, bgColor: Color.systemGray3) {
				Task {
					await propertyStore.deleteSchedule(availability, propertyId: calendarViewModel.property.id)
				}
			}
		}
	}
	
	var availableList: some View {
		ForEach(calendarViewModel.property.available.current().dateSorted()) { availability in
			AvailabilityTileView(availibility: availability, bgColor: Color.systemGray3) {
				Task {
					await propertyStore.deleteSchedule(availability, propertyId: calendarViewModel.property.id)
				}
			}
		}
	}
	
	var doneButton: some View {
		Button(action: {
			if (calendarViewModel.startDate != nil) {
				Task {
					if let error = await propertyStore.addSchedule(
						startDate: calendarViewModel.startDate,
						endDate: calendarViewModel.endDate,
						type: calendarViewModel.mode,
						property: calendarViewModel.property) {
						calendarViewModel.error = error
					} else {
						calendarViewModel.resetDates()
					}
				}
			} else {
				propertyStore.showOwnedAvailabilitySheet.toggle()
			}
		}, label: {
			Text(calendarViewModel.startDate != nil ? "Set" : "Done")
				.font(.headline).fontWeight(.semibold)
				.frame(maxWidth: .infinity)
				.padding(.vertical, 12)
				.foregroundColor(.white)
				.background((calendarViewModel.startDate != nil) || (calendarViewModel.startDate == nil && calendarViewModel.endDate == nil) ? Color.systemBlue.opacity(0.6) : Color.systemGray3)
				.cornerRadius(5)
		})
	}
}

//struct BookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingView()
//    }
//}
