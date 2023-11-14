//
//  CalendarCellView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import SwiftUI

struct CalendarCell: View {
    @StateObject var viewModel: CalendarCell.ViewModel
    @ObservedObject var calendarViewModel: CalendarView.ViewModel
    
    init(count: Int, calendarViewModel: CalendarView.ViewModel, property: Property) {
        self._viewModel = StateObject(wrappedValue: ViewModel(count: count, calendarViewModel: calendarViewModel, property: property))
        self.calendarViewModel = calendarViewModel
    }
    
    var body: some View {
        Button(action: {
            calendarViewModel.dateClicked(viewModel.date)
            print(viewModel.highlighted)
        }, label: {
            Text(String(viewModel.day))
                .strikethrough(viewModel.booked)
                .padding(Constants.Padding.xsmall)
                .foregroundColor(calendarViewModel.date.get(.month) == viewModel.month ? Color.black : Color.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    if viewModel.highlighted {
//                        Color.blue.opacity(0.5)
//                            .clipShape(
//                                .rect(
//                                    topLeadingRadius: 0,
//                                    bottomLeadingRadius: 20,
//                                    bottomTrailingRadius: 0,
//                                    topTrailingRadius: 20
//                                )
//                        )
                        Color.blue.opacity(0.5)
                    }
                }
                .onChange(of: calendarViewModel.startDate) { _ in
                    viewModel.updateHighlighted()
                }
                .onChange(of: calendarViewModel.endDate) { _ in
                    viewModel.updateHighlighted()
                }
                .onChange(of: calendarViewModel.date) { _ in
                    viewModel.update()
                }
        })
    }
}

extension CalendarCell {
    class ViewModel: ObservableObject {
        @ObservedObject var calendarViewModel: CalendarView.ViewModel
        @Published var highlighted: Bool
        @Published var isStart: Bool
        @Published var isEnd: Bool
        @Published var booked: Bool
        
        let count: Int
        let property: Property
        @Published var year: Int
        @Published var month: Int
        @Published var day: Int
        @Published var date: Date
        
        init(count: Int, calendarViewModel: CalendarView.ViewModel, property: Property) {
            self.count = count
            self.calendarViewModel = calendarViewModel
            self.property = property
            self.booked = false
            self.year = calendarViewModel.date.get(.year)
            self.month = calendarViewModel.date.get(.month)
            self.day = calendarViewModel.date.get(.day)
            self.date = Date()
            self.highlighted = false
            self.isEnd = false
            self.isStart = false
            setDate()
            updateBooked()
            updateHighlighted()
        }
        
        func updateHighlighted() {
            if let start = calendarViewModel.startDate {
                self.isStart = start == self.date
            }
            if let end = calendarViewModel.endDate {
                self.isEnd = end == self.date
            }
            
            self.highlighted = false
            
            if let start = calendarViewModel.startDate {
                self.highlighted = start == self.date
            } else if let end = calendarViewModel.endDate {
                self.highlighted = end == self.date
            }
            
            if let start = calendarViewModel.startDate, let end = calendarViewModel.endDate {
                self.highlighted = (start...end).contains(self.date)
            }
        }
        
        func update() {
            self.booked = false
            self.year = calendarViewModel.date.get(.year)
            self.month = calendarViewModel.date.get(.month)
            self.day = calendarViewModel.date.get(.day)
            self.date = Date()
            self.highlighted = false
            self.isEnd = false
            self.isStart = false
            setDate()
            updateBooked()
            updateHighlighted()
        }
        
        func setDate() {
            let daysInMonth = calendarViewModel.date.daysInMonth()
            let startingSpaces = calendarViewModel.date.firstOfMonth().weekDay()
            let daysInPrevMonth = calendarViewModel.date.minusMonth().daysInMonth()
            
            let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
            if count <= start {
                self.day = daysInPrevMonth + count - start
                self.month = calendarViewModel.date.minusMonth().get(.month)
            } else if count - start > daysInMonth {
                self.day = count - start - daysInMonth
                self.month = calendarViewModel.date.plusMonth().get(.month)
            } else {
                self.day = count - start
            }
            
            let calendar = Calendar(identifier: .gregorian)
            self.date = calendar.date(from: DateComponents(year: self.year, month: self.month, day: self.day))!.stripTime()
        }
        
        func updateBooked() {
            let monthYear = self.date.monthYearString()
            guard property.bookings.keys.contains(monthYear) else {
                return
            }

            for booking in property.bookings[monthYear]! {
                if booking.overlaps(date: self.date) {
                    self.booked = true
                    break
                }
            }
        }
    }
}

//struct CalendarCell_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1)
//    }
//}
