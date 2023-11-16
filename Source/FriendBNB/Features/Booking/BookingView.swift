//
//  BookingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-14.
//

import SwiftUI

struct BookingView: View {
    @EnvironmentObject var bookingManager: BookingManager
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text("Your Boooking")
                        .font(.largeTitle).fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, Constants.Spacing.small)
                    Text("Confirm your dates:")
                        .font(.title3).fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(bookingManager.error ?? "")
                        .font(.title3).fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    CalendarView()
                        .padding(.horizontal, Constants.Padding.regular)
                        .frame(maxHeight: 300)
                    Spacer()
                }
                
            }
            
            VStack {
                Spacer()
                PairButtonsView(prevText: "Back", prevAction: {
                    bookingManager.hideBookingSheet()
                }, nextText: "Confirm", nextAction: {
                    Task {
                        await bookingManager.createBooking()
                    }
                })
            }
        }
        .onTapGesture {
            bookingManager.startDate = nil
            bookingManager.endDate = nil
        }
        .padding(.horizontal, Constants.Padding.regular)
        .padding(.top, Constants.Padding.small)
    }
}

//struct BookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingView()
//    }
//}
