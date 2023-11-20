//
//  NewBookingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-14.
//

import SwiftUI

struct NewBookingView: View {
    @EnvironmentObject var bookingManager: BookingManager
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text("New Boooking")
                        .font(.largeTitle).fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, Constants.Spacing.small)
                    Text("Confirm your dates:")
                        .font(.title3).fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    CalendarView()
                        .padding(.horizontal, Constants.Padding.regular)
                        .frame(maxHeight: 300)
                    
                    Text(bookingManager.error ?? "")
                        .font(.headline).fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.systemRed)
                    Spacer()
                }
                
            }
            
            VStack {
                Spacer()
                PairButtonsView(prevText: "Back", prevAction: {
                    bookingManager.showNewBookingSheet = false
                }, nextText: "Confirm", nextAction: {
                    Task {
                        await bookingManager.createBooking()
                    }
                })
            }
        }
        .padding(.horizontal, Constants.Padding.regular)
        .padding(.top, Constants.Padding.small)
        
        .onTapGesture {
            bookingManager.startDate = nil
            bookingManager.endDate = nil
        }
        
        .onAppear {
            bookingManager.subscribe()
        }
        .onDisappear {
            bookingManager.unsubscribe()
        }
    }
}

//struct BookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingView()
//    }
//}
