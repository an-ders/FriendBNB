//
//  BookingTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-20.
//

import SwiftUI

struct BookingTileView: View {
    @EnvironmentObject var bookingManager: BookingManager
    var booking: Booking
    
    @State var deleteConfirm = false
    
    var body: some View {
        HStack {
            VStack {
                Text(booking.start, style: .date)
                Text(booking.end, style: .date)
            }
            
            Spacer()
            
            Button(action: {
                deleteConfirm = true
            }, label: {
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
            })
        }
        .padding(Constants.Padding.regular)
        .background(Color.systemGray3)
        .cornerRadius(20)
        .alert(isPresented: $deleteConfirm) {
            Alert(title: Text("Are you sure you want to delete this booking?"),
                  primaryButton: .destructive(Text("Delete")) {
                Task {
                    await bookingManager.deleteBooking(booking)
                }
            },
                  secondaryButton: .default(Text("Cancel")))
        }
    }
}

//#Preview {
//    BookingTileView()
//}
