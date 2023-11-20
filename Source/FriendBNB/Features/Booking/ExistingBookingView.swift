//
//  ExistingBookingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-20.
//

import SwiftUI
import FirebaseAuth

struct ExistingBookingView: View {
    @EnvironmentObject var bookingManager: BookingManager
    
    var body: some View {
        if bookingManager.filteredBookings.isEmpty {
            VStack {
                Image(systemName: "house")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                Text("It's empty in here.")
                    .font(.title).fontWeight(.medium)
                Text("Create a new booking")
                    .font(.headline).fontWeight(.light)
                    .padding(.bottom, 8)
                
                Button(action: {
                    Task {
                        bookingManager.showExistingBookingSheet = false
                        try? await Task.sleep(nanoseconds: 400000000)
                        bookingManager.showNewBookingSheet = true
                    }
                }, label: {
                    Text("New Booking")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(Color.systemGray3)
                        .cornerRadius(10)
                })
            }
        } else {
            ZStack {
                VStack {
                    Text("Your Boookings")
                        .font(.largeTitle).fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, Constants.Spacing.small)
                    
                    ScrollView {
                        VStack {
                            ForEach(bookingManager.property.bookings.filter({ $0.userId == Auth.auth().currentUser?.uid ?? "" })) { booking in
                                BookingTileView(booking: booking)
                            }
                        }
                    }
                    
                    
                }
                
                VStack {
                    Spacer()
                    PairButtonsView(prevText: "", prevAction: {}, nextText: "Back", nextAction: {
                        bookingManager.showExistingBookingSheet = false
                    })
                }
            }
            .interactiveDismissDisabled()
            .padding(.horizontal, Constants.Padding.regular)
            .padding(.top, Constants.Padding.small)
        }
    }
}

#Preview {
    ExistingBookingView()
}
