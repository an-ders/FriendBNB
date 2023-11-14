//
//  CalendarView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-12.
//

import SwiftUI

struct CalendarView: View {
    @StateObject var viewModel = ViewModel()
    var property: Property
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.previousMonth()
                }, label: {
                    Image(systemName: "arrow.left")
                        .imageScale(.large)
                        .font(Font.title.weight(.bold))
                })
                
                Text(viewModel.date.monthYearString())
                    .font(.title)
                    .bold()
                    .animation(.none)
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    viewModel.nextMonth()
                }, label: {
                    Image(systemName: "arrow.right")
                        .imageScale(.large)
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
                        
                        CalendarCell(count: count,
                                     calendarViewModel: viewModel,
                                     property: property)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

extension CalendarView {
    class ViewModel: ObservableObject {
        @Published var date = Date()
        @Published var startDate: Date?
        @Published var endDate: Date?
        
        func previousMonth() {
            self.date = date.minusMonth()
        }
        
        func nextMonth() {
            self.date = date.plusMonth()
        }
        
        func dateClicked(_ date: Date) {
            if startDate != nil && endDate != nil {
                startDate = date
                endDate = nil
            } else if startDate == nil && endDate == nil {
                startDate = date
                endDate = nil
            } else {
                guard startDate != nil else {
                    return
                }
                if date < startDate! {
                    endDate = startDate
                    startDate = date
                } else {
                    endDate = date
                }
            }
        }
    }
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
