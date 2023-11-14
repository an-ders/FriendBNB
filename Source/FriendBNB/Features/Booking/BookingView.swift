//
//  BookingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-14.
//

import SwiftUI

struct BookingView: View {
    var property: Property
    
    var body: some View {
        ScrollView {
            VStack {
                CalendarView(property: property)
                    .padding(.horizontal, Constants.Padding.regular)
                    .frame(height: 300)
            }
        }
        .padding(.horizontal, Constants.Padding.small)
        .padding(.top, Constants.Padding.small)
    }
}

//struct BookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingView()
//    }
//}
