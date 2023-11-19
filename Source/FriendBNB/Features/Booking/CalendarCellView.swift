//
//  CalendarCellView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import SwiftUI

struct CalendarCell: View {
    @StateObject var viewModel: CalendarCell.ViewModel
    @EnvironmentObject var bookingManager: BookingManager
    
    init(count: Int, bookingManager: BookingManager) {
        self._viewModel = StateObject(wrappedValue: ViewModel(count: count, bookingManager: bookingManager))
    }
    
    var body: some View {
        Button(action: {
            bookingManager.dateClicked(viewModel.date)
        }, label: {
            Text(String(viewModel.day))
                .strikethrough(viewModel.isBooked)
                .padding(Constants.Padding.xsmall)
                .foregroundColor(bookingManager.date.get(.month) == viewModel.month ? viewModel.isBooked ? Color.systemGray : Color.black : Color.systemGray4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    if viewModel.isHighlighted && bookingManager.startDate != nil && bookingManager.endDate != nil {
                        Color.blue.opacity(0.5)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: viewModel.isStartDate ? 20 : 0,
                                    bottomLeadingRadius: viewModel.isStartDate ? 20 : 0,
                                    bottomTrailingRadius: viewModel.isEndDate ? 20 : 0,
                                    topTrailingRadius: viewModel.isEndDate ? 20 : 0
                                )
                        )
                    } else if viewModel.isHighlighted && bookingManager.endDate == nil {
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
                    }
                }
                .onChange(of: bookingManager.startDate) { _ in
                    viewModel.update(bookingManager)
                }
                .onChange(of: bookingManager.endDate) { _ in
                    viewModel.update(bookingManager)
                }
                .onChange(of: bookingManager.date) { _ in
                    viewModel.update(bookingManager)
                }
                .onChange(of: bookingManager.property.bookings) { _ in
                    viewModel.update(bookingManager)
                }
        })
    }
}

extension CalendarCell {
    @MainActor
    class ViewModel: ObservableObject {
        let count: Int
        @Published var year: Int
        @Published var month: Int
        @Published var day: Int
        @Published var date: Date
        @Published var isHighlighted: Bool
        @Published var isBooked: Bool
        @Published var isStartDate: Bool
        @Published var isEndDate: Bool
        
        init(count: Int, bookingManager: BookingManager) {
            self.count = count
            self.year = bookingManager.date.get(.year)
            self.month = bookingManager.date.get(.month)
            self.day = bookingManager.date.get(.day)
            self.date = Date()
            self.isHighlighted = false
            self.isBooked = false
            self.isStartDate = false
            self.isEndDate = false
            
            update(bookingManager)
        }
        
        func update(_ bookingManager: BookingManager) {
            self.year = bookingManager.date.get(.year)
            self.month = bookingManager.date.get(.month)
            self.day = bookingManager.date.get(.day)
            self.date = Date()
            setDate(bookingManager.date)
            
            isHighlighted = bookingManager.isHightlighted(date)
            isBooked = bookingManager.isBooked(date)
            
            self.isStartDate = false
            self.isEndDate = false
            if let startDate = bookingManager.startDate, let endDate = bookingManager.endDate {
                self.isStartDate = self.date == startDate
                self.isEndDate = self.date == endDate
            }
        }
        
        func setDate(_ date: Date) {
            let daysInMonth = date.daysInMonth()
            let startingSpaces = date.firstOfMonth().weekDay()
            let daysInPrevMonth = date.minusMonth().daysInMonth()
            
            let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
            if count <= start {
                self.day = daysInPrevMonth + count - start
                self.month = date.minusMonth().get(.month)
            } else if count - start > daysInMonth {
                self.day = count - start - daysInMonth
                self.month = date.plusMonth().get(.month)
            } else {
                self.day = count - start
            }
            
            let calendar = Calendar(identifier: .gregorian)
            self.date = calendar.date(from: DateComponents(year: self.year, month: self.month, day: self.day))!.stripTime()
        }
    }
}

//struct CalendarCell_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1)
//    }
//}
