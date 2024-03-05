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
	@EnvironmentObject var authStore: AuthenticationStore
	@Environment(\.dismiss) private var dismiss
	
	@StateObject var calendarViewModel: CalendarViewModel
	@State var confirmBooking: Booking?
	
	init(property: Property) {
		self._calendarViewModel = StateObject(wrappedValue: CalendarViewModel(property: property))
	}
	
	var body: some View {
		if let property = propertyStore.friendSelectedProperty {
			NavigationStack {
				VStack(spacing: 0) {
					VStack(spacing: 0) {
						DetailSheetTitle(title: "REQUEST BOOKING")
							.padding(.horizontal, Constants.Spacing.medium)
							.padding(.vertical, Constants.Spacing.large)

						Divider()
							.padding(.horizontal, -Constants.Spacing.regular)
					}

					ScrollView {
						VStack(spacing: Constants.Spacing.small) {
							CalendarView(type: .friend)
								.environmentObject(calendarViewModel)
								.padding(.horizontal, Constants.Spacing.regular)
								.frame(maxHeight: 300)
							
							Text(calendarViewModel.error)
								.font(.headline).fontWeight(.light)
								.frame(maxWidth: .infinity, alignment: .leading)
								.foregroundColor(Color.systemRed)
							
							let months = property.available.current().dateSorted().arrayMonths()
							
							if !months.isEmpty {
								HStack(alignment: .top) {
									Text("Available Months:")
										.styled(.body)
										.frame(maxWidth: .infinity, alignment: .center)
									VStack {
										ForEach(Array(months), id: \.self) { date in
											Button(action: {
												calendarViewModel.date = date
											}, label: {
												Text(date.monthYearString())
													.styled(.body)
													.frame(maxWidth: .infinity, alignment: .center)
													.padding(.bottom, Constants.Spacing.xsmall)
											})
										}
									}
								}
							}
							
							Spacer()
						}
						.padding(.top, Constants.Spacing.large)
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
				.onTapGesture {
					calendarViewModel.resetDates()
				}
				.onAppear {
					calendarViewModel.subscribe()
				}
				.onDisappear {
					calendarViewModel.unsubscribe()
				}
				.navigationDestination(item: $confirmBooking) { booking in
					BookingConfirmationView(property: property, booking: booking, showDismiss: false) {
						PairButtonsView(prevText: "Back", prevAction: {
							confirmBooking = nil
						}, nextText: "Send Request", nextCaption: "", nextAction: {
							Task {
								if let error = await bookingStore.createBooking(startDate: calendarViewModel.startDate, endDate: calendarViewModel.endDate, property: calendarViewModel.property) {
									calendarViewModel.error = error
								} else {
									notificationStore.pushNotification(message: "Booking sent for confirmation.")
									calendarViewModel.resetDates()
									await propertyStore.fetchProperties(.friend)
									dismiss()
								}
							}
						})
						.padding(.horizontal, Constants.Spacing.regular)
					}
					.padding(.top, -Constants.Spacing.medium)
				}
			}
		} else {
			NoSelectedPropertyView()
		}
	}
	
	var doneButton: some View {
		Button(action: {
			guard let start = calendarViewModel.startDate else {
				dismiss()
				return
			}
			guard let end = calendarViewModel.endDate else {
				self.calendarViewModel.error = "Please choose an end date."
				return
			}
			
			guard let property = propertyStore.friendSelectedProperty else {  return }
			
			if let error = bookingStore.checkBookingDates(startDate: calendarViewModel.startDate, endDate: calendarViewModel.endDate, property: property), error != "Unknown" {
				self.calendarViewModel.error = error
				return
			}
			
			guard let user = authStore.user else {
				self.calendarViewModel.error = "Error with your account"
				return
			}
			
			self.confirmBooking = Booking(id: "", start: start, end: end, userId: user.uid, email: user.email, name: user.displayName, status: .pending, statusMessage: "", sensitiveInfo: [])
			
		}, label: {
			Text(calendarViewModel.startDate != nil || calendarViewModel.endDate != nil ? "Request" : "Done")
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
