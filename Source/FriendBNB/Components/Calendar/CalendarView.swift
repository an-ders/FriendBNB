//
//  CalendarView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import SwiftUI
import FirebaseFirestore

struct CalendarSettings {
	var bookingStrikeThrough = true
	var unavailableStrikeThrough = true
	
	var greyBooked = true
	var greyUnavailable = true
	
}

struct CalendarView: View {
	@EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var calendarViewModel: CalendarViewModel
	
	var type: PropertyType
	
	var body: some View {
		VStack {
			HStack {
				Spacer()
				Button(action: {
					calendarViewModel.previousMonth()
				}, label: {
					Image(systemName: "arrow.left")
						.imageScale(.medium)
						.font(Font.title.weight(.bold))
				})
				
				Text(calendarViewModel.date.monthYearString())
					.font(.title)
					.bold()
					.animation(.none)
					.frame(maxWidth: .infinity)
				
				Button(action: {
					calendarViewModel.nextMonth()
				}, label: {
					Image(systemName: "arrow.right")
						.imageScale(.medium)
						.font(Font.title.weight(.bold))
				})
				Spacer()
			}
			
			daysOfTheWeek
			
			daysGrid
		}
	}
	
	var daysOfTheWeek: some View {
		HStack(spacing: 1) {
			ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
				Text(day)
					.frame(maxWidth: .infinity)
					.padding(.top, 1)
					.lineLimit(1)
			}
		}
	}
	
	var daysGrid: some View {
		VStack(spacing: 2) {
			ForEach(0..<6) { row in
				HStack(spacing: 0) {
					ForEach(1..<8) { column in
						let count = column + (row * 7)
						CalendarCellView(type: type, viewModel: CalendarCellView.ViewModel(count: count, calendarViewModel: calendarViewModel))
					}
				}
			}
		}
		.frame(maxHeight: .infinity)
	}
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
