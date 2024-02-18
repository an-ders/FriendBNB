//
//  CalendarFriendCellView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import SwiftUI

struct CalendarFriendCellView: View {
	@EnvironmentObject var calendarViewModel: CalendarViewModel
	@StateObject var viewModel: ViewModel
	
	var body: some View {
		Button(action: {
			calendarViewModel.dateClicked(viewModel.date)
			//print("\(viewModel.day) \(viewModel.month) \(viewModel.year)")
		}, label: {
			Text(String(viewModel.day))
			.strikethrough(viewModel.isBooked || viewModel.isUnavailable)
				.padding(Constants.Padding.xsmall)
				//.foregroundColor(viewModel.isCurrentMonth ? Color.black : Color.systemGray4)
				.foregroundColor(viewModel.isCurrentMonth ? viewModel.isBooked || viewModel.isUnavailable ? Color.systemGray : Color.black : Color.systemGray4)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background {
					if viewModel.isHighlighted && calendarViewModel.endDate == nil {
						Color.blue.opacity(0.5)
							.clipShape(
								.rect(
									topLeadingRadius: 20,
									bottomLeadingRadius: 20,
									bottomTrailingRadius: 20,
									topTrailingRadius: 20
								)
							)
					} else if viewModel.isHighlighted {
						Color.blue.opacity(0.5)
							.clipShape(
								.rect(
									topLeadingRadius: viewModel.isStartDate ? 20 : 0,
									bottomLeadingRadius: viewModel.isStartDate ? 20 : 0,
									bottomTrailingRadius: viewModel.isEndDate ? 20 : 0,
									topTrailingRadius: viewModel.isEndDate ? 20 : 0
								)
							)
					} else if viewModel.isUnavailable && !viewModel.isAvailable {
						Color.systemRed.opacity(0.5)
					} else if viewModel.isAvailable && viewModel.isAvailable && !viewModel.isUnavailable {
						Color.green.opacity(0.5)
					}
				}
				.onChange(of: calendarViewModel.manualUpdate) { _ in
					viewModel.update(calendarViewModel: calendarViewModel)
				}
				.onChange(of: calendarViewModel.startDate) { _ in
					viewModel.update(calendarViewModel: calendarViewModel)
				}
				.onChange(of: calendarViewModel.endDate) { _ in
					viewModel.update(calendarViewModel: calendarViewModel)
				}
				.onChange(of: calendarViewModel.date) { _ in
					viewModel.update(calendarViewModel: calendarViewModel)
				}
				.onChange(of: calendarViewModel.property.bookings) { _ in
					viewModel.update(calendarViewModel: calendarViewModel)
				}
				.onChange(of: calendarViewModel.property.available) { _ in
					viewModel.update(calendarViewModel: calendarViewModel)
				}
				.onChange(of: calendarViewModel.property.unavailable) { _ in
					viewModel.update(calendarViewModel: calendarViewModel)
				}
		})
	}
}

extension CalendarFriendCellView {
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
		@Published var isUnavailable = false
		
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
				isCurrentMonth = false
			} else if count - start > daysInMonth {
				self.day = count - start - daysInMonth
				self.month = date.plusMonth().get(.month)
				isCurrentMonth = false
			} else {
				self.day = count - start
				isCurrentMonth = true
			}
			
			let calendar = Calendar(identifier: .gregorian)
			self.date = calendar.date(from: DateComponents(year: self.year, month: self.month, day: self.day))!.stripTime()
		}
		
		func updateHighlighting(startDate: Date?, endDate: Date?) {
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
			
			for avilability in dict[monthYear]! where avilability.overlaps(date: date) {
				isAvailable = true
				return
			}
			
			isAvailable = false
		}
		//
		func updateisUnavailable(_ unavailable: [Booking]) {
			let monthYear = date.monthYearString()
			let dict = unavailable.dict()
			guard dict.keys.contains(monthYear) else {
				isUnavailable = false
				return
			}
			
			for unavilability in dict[monthYear]! where unavilability.overlaps(date: date) {
				isUnavailable = true
				return
			}
			
			isUnavailable = false
		}
	}
}

//struct CalendarFriendCellView: View {
//    @StateObject var viewModel: ViewModel
//    @EnvironmentObject var bookingManager: BookingStore
//    
//    init(count: Int, bookingManager: BookingStore) {
//        self._viewModel = StateObject(wrappedValue: ViewModel(count: count, bookingManager: bookingManager))
//    }
//    
//    var body: some View {
//        Button(action: {
//            bookingManager.dateClicked(viewModel.date)
//        }, label: {
//            Text(String(viewModel.day))
//                .strikethrough(viewModel.isBooked || viewModel.isUnavailable)
//                .padding(Constants.Padding.xsmall)
//                .foregroundColor(bookingManager.date.get(.month) == viewModel.month ? (!viewModel.isBooked && viewModel.isAvailable && !viewModel.isUnavailable) ? Color.black : Color.systemGray2 : Color.systemGray5)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background {
//                    if viewModel.isHighlighted && bookingManager.endDate == nil {
//                        Color.blue.opacity(0.5)
//                            .clipShape(
//                                .rect(
//                                    topLeadingRadius: 20,
//                                    bottomLeadingRadius: 20,
//                                    bottomTrailingRadius: 20,
//                                    topTrailingRadius: 20
//                                )
//                        )
//                    } else if viewModel.isHighlighted {
//                        Color.blue.opacity(0.5)
//                            .clipShape(
//                                .rect(
//                                    topLeadingRadius: viewModel.isStartDate ? 20 : 0,
//                                    bottomLeadingRadius: viewModel.isStartDate ? 20 : 0,
//                                    bottomTrailingRadius: viewModel.isEndDate ? 20 : 0,
//                                    topTrailingRadius: viewModel.isEndDate ? 20 : 0
//                                )
//                            )
//                    }
//                }
//                .onChange(of: bookingManager.startDate) { _ in
//                    viewModel.update(bookingManager)
//                }
//                .onChange(of: bookingManager.endDate) { _ in
//                    viewModel.update(bookingManager)
//                }
//                .onChange(of: bookingManager.date) { _ in
//                    viewModel.update(bookingManager)
//                }
//                .onChange(of: bookingManager.property.bookings) { _ in
//                    viewModel.update(bookingManager)
//                }
//                .onChange(of: bookingManager.property.available) { _ in
//                    viewModel.update(bookingManager)
//                }
//                .onChange(of: bookingManager.property.unavailable) { _ in
//                    viewModel.update(bookingManager)
//                }
//        })
//    }
//}
//
//extension CalendarFriendCellView {
//    @MainActor
//    class ViewModel: ObservableObject {
//        let count: Int
//        @Published var year: Int
//        @Published var month: Int
//        @Published var day: Int
//        @Published var date: Date
//        @Published var isHighlighted: Bool
//        @Published var isBooked: Bool
//        @Published var isStartDate: Bool
//        @Published var isEndDate: Bool
//        @Published var isAvailable: Bool
//        @Published var isUnavailable: Bool
//        
//        init(count: Int, bookingManager: BookingStore) {
//            self.count = count
//            self.year = bookingManager.date.get(.year)
//            self.month = bookingManager.date.get(.month)
//            self.day = bookingManager.date.get(.day)
//            self.date = Date()
//            self.isHighlighted = false
//            self.isBooked = false
//            self.isStartDate = false
//            self.isEndDate = false
//            self.isAvailable = false
//            self.isUnavailable = false
//            
//            update(bookingManager)
//        }
//        
//        func update(_ bookingManager: BookingStore) {
//            self.year = bookingManager.date.get(.year)
//            self.month = bookingManager.date.get(.month)
//            self.day = bookingManager.date.get(.day)
//            self.date = Date()
//            setDate(bookingManager.date)
//            
//            isHighlighted = bookingManager.isHightlighted(date)
//            isBooked = bookingManager.isBooked(date)
//            isAvailable = bookingManager.isAvailabile(date)
//            isUnavailable = bookingManager.isBusy(date)
//            
//            self.isStartDate = false
//            self.isEndDate = false
//            if let startDate = bookingManager.startDate, let endDate = bookingManager.endDate {
//                self.isStartDate = self.date == startDate
//                self.isEndDate = self.date == endDate
//            }
//        }
//        
//        func setDate(_ date: Date) {
//            let daysInMonth = date.daysInMonth()
//            let startingSpaces = date.firstOfMonth().weekDay()
//            let daysInPrevMonth = date.minusMonth().daysInMonth()
//            
//            let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
//            if count <= start {
//                self.day = daysInPrevMonth + count - start
//                self.month = date.minusMonth().get(.month)
//            } else if count - start > daysInMonth {
//                self.day = count - start - daysInMonth
//                self.month = date.plusMonth().get(.month)
//            } else {
//                self.day = count - start
//            }
//            
//            let calendar = Calendar(identifier: .gregorian)
//            self.date = calendar.date(from: DateComponents(year: self.year, month: self.month, day: self.day))!.stripTime()
//        }
//    }
//}
//
////struct CalendarCell_Previews: PreviewProvider {
////    static var previews: some View {
////        CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1)
////    }
////}
