//
//  FriendNewBookingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-14.
//

import SwiftUI

struct FriendNewBookingView: View {
	@EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var propertyStore: PropertyStore
	@EnvironmentObject var notificationStore: NotificationStore
	@Environment(\.dismiss) private var dismiss
	
	@StateObject var calendarViewModel: CalendarViewModel
	init(property: Property) {
		self._calendarViewModel = StateObject(wrappedValue: CalendarViewModel(property: property))
	}
	
	var body: some View {
		VStack {
			ScrollView {
				VStack(spacing: Constants.Spacing.xsmall) {
					Text("New Boooking")
						.font(.largeTitle).fontWeight(.medium)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, Constants.Spacing.small)
					Text("Confirm your dates:")
						.body()
						.fillLeading()
						.padding(.bottom, Constants.Spacing.small)
					
					CalendarView(type: .friend)
						.environmentObject(calendarViewModel)
						.padding(.horizontal, Constants.Padding.regular)
						.frame(maxHeight: 300)
					
					Text(calendarViewModel.error)
						.font(.headline).fontWeight(.light)
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundColor(Color.systemRed)
					
					HStack(alignment: .top) {
						Text("Available Months")
							.body()
							.frame(maxWidth: .infinity, alignment: .center)
						VStack {
							ForEach(Array(propertyStore.selectedFriendProperty!.available.current().dateSorted().arrayMonths()), id: \.self) { date in
								Button(action: {
									calendarViewModel.date = date
								}, label: {
									Text(date.monthYearString())
										.body()
										.frame(maxWidth: .infinity, alignment: .center)
										.padding(.bottom, Constants.Padding.xsmall)
								})
							}
						}
					}
					Spacer()
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
					if let error = await bookingStore.createBooking(startDate: calendarViewModel.startDate, endDate: calendarViewModel.endDate, property: calendarViewModel.property) {
						calendarViewModel.error = error
					} else {
						notificationStore.pushNotification(message: "Booking sent for confirmation.")
						calendarViewModel.resetDates()
						dismiss()
					}
				}
			} else {
				dismiss()
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
