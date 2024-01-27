//
//  FriendNewBookingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-14.
//

import SwiftUI

struct FriendNewBookingView: View {
	@EnvironmentObject var bookingStore: BookingStore
	@Environment(\.dismiss) private var dismiss
	
	@StateObject var calendarViewModel: CalendarViewModel
	init(property: Property) {
		self._calendarViewModel = StateObject(wrappedValue: CalendarViewModel(property: property))
	}
	
	var body: some View {
		PairButtonWrapper(prevText: "Back", prevAction: {
			dismiss()
		}, nextText: "Confirm", nextAction: {
			Task {
				if let error = await bookingStore.createBooking(startDate: calendarViewModel.startDate, endDate: calendarViewModel.endDate, property: calendarViewModel.property) {
					calendarViewModel.error = error
				} else {
					// SEND CONFIRMATION NOTIFICATION OR SCREEN
					calendarViewModel.resetDates()
					dismiss()
				}
			}
		}, content: {
			ScrollView {
				VStack {
					Text("New Boooking")
						.font(.largeTitle).fontWeight(.medium)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, Constants.Spacing.small)
					Text("Confirm your dates:")
						.font(.title3).fontWeight(.light)
						.frame(maxWidth: .infinity, alignment: .leading)
					
					CalendarView(type: .friend)
						.environmentObject(calendarViewModel)
						.padding(.horizontal, Constants.Padding.regular)
						.frame(maxHeight: 300)
					
					Text(calendarViewModel.error)
						.font(.headline).fontWeight(.light)
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundColor(Color.systemRed)
					Spacer()
				}
			}
		})
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
}

//struct BookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingView()
//    }
//}
