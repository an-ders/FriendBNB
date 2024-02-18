//
//  CalendarCellViewModel.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import Foundation

extension CalendarCellView {
	@MainActor
	class ViewModel: ObservableObject {
		let count: Int
		@Published var year: Int = 0
		@Published var month: Int = 0
		@Published var day: Int = 0
		@Published var date = Date()
		
		@Published var isCurrentMonth = false
		@Published var isStartDate = false
		@Published var isEndDate = false
		@Published var isHighlighted = false
		@Published var isBooked = false
		@Published var isAvailable = false
		@Published var isAvailableStart = false
		@Published var isAvailableEnd = false
		@Published var isUnavailable = false
		@Published var isUnavailableStart = false
		@Published var isUnavailableEnd = false
		
		init(count: Int, calendarViewModel: CalendarViewModel) {
			self.count = count
			
			update(calendarViewModel: calendarViewModel)
		}
		
		func update(calendarViewModel: CalendarViewModel) {
			updateDate(calendarViewModel.date)
			updateHighlighting(startDate: calendarViewModel.startDate, endDate: calendarViewModel.endDate)
			updateIsBooked(calendarViewModel.property.bookings)
			updateIsAvailabile(calendarViewModel.property.available)
			updateisUnavailable(calendarViewModel.property.unavailable)
		}
		
		func updateDate(_ date: Date) {
			self.month = date.get(.month)
			self.year = date.get(.year)
			
			let daysInMonth = date.daysInMonth()
			let startingSpaces = date.firstOfMonth().weekDay()
			let daysInPrevMonth = date.minusMonth().daysInMonth()
			
			let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
			if self.count <= start {
				self.day = daysInPrevMonth + count - start
				self.month = date.minusMonth().get(.month)
				if self.month == 12 {
					self.year -= 1
				}
				isCurrentMonth = false
			} else if count - start > daysInMonth {
				self.day = count - start - daysInMonth
				self.month = date.plusMonth().get(.month)
				if self.month == 1 {
					self.year += 1
				}
				isCurrentMonth = false
			} else {
				self.day = count - start
				isCurrentMonth = true
			}
			
			let calendar = Calendar(identifier: .gregorian)
			self.date = calendar.date(from: DateComponents(year: self.year, month: self.month, day: self.day))!.stripTime()
			
			if self.date < Date().stripTime() {
				isCurrentMonth = false
			}
		}
		
		func updateHighlighting(startDate: Date?, endDate: Date?) {
			isHighlighted = false
			
			if let start = startDate {
				isHighlighted = start == date
				isStartDate = start == date
			}
			
			if let end = endDate {
				isHighlighted = end == date
				isEndDate = end == date
			}
			
			if let start = startDate, let end = endDate {
				isHighlighted = (start...end).contains(date)
			}
		}
		
		func updateIsBooked(_ bookings: [Booking]) {
			let monthYear = date.monthYearString()
			let dict = bookings.dict()
			guard dict.keys.contains(monthYear) else {
				isBooked = false
				return
			}
			
			for booking in dict[monthYear]! where booking.overlaps(date: date) {
				isBooked = true
				return
			}
			
			isBooked = false
		}
		
		func updateIsAvailabile(_ available: [Booking]) {
			let monthYear = date.monthYearString()
			let dict = available.dict()
			guard dict.keys.contains(monthYear) else {
				isAvailable = false
				return
			}
			
			isAvailable = false
			isAvailableStart = false
			isAvailableEnd = false
			
			for avilability in dict[monthYear]! where avilability.overlaps(date: date) {
				isAvailable = true
				isAvailableStart = avilability.start == date
				isAvailableEnd = avilability.end == date
				return
			}
			
		}
		//
		func updateisUnavailable(_ unavailable: [Booking]) {
			let monthYear = date.monthYearString()
			let dict = unavailable.dict()
			guard dict.keys.contains(monthYear) else {
				isUnavailable = false
				return
			}
			
			isUnavailable = false
			isUnavailableStart = false
			isUnavailableEnd = false
			
			for unavilability in dict[monthYear]! where unavilability.overlaps(date: date) {
				isUnavailable = true
				isUnavailableStart = unavilability.start == date
				isUnavailableEnd = unavilability.end == date
				return
			}
		}
	}
}
