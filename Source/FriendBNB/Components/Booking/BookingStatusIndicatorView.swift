//
//  BookingStatusIndicatorView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import SwiftUI

struct BookingStatusIndicatorView: View {
	var status: BookingStatus
	
	let disabledOpacity = 0.3
    var body: some View {
		VStack {
			HStack {
				Spacer()
				
				Circle()
					.scaledToFit()
					.frame(width: 40)
					.foregroundStyle(Color.systemRed.opacity(status == .declined ? 1 : disabledOpacity))
				
				Spacer()
				
				Circle()
					.scaledToFit()
					.frame(width: 40)
					.foregroundStyle(Color.systemYellow.opacity(status == .pending ? 1 : disabledOpacity))
				
				Spacer()
				
				Circle()
					.scaledToFit()
					.frame(width: 40)
					.foregroundStyle(Color.systemGreen.opacity(status == .confirmed ? 1 : disabledOpacity))
				
				Spacer()
			}
			
			Text(status.rawValue)
		}
    }
}

//#Preview {
//    BookingStatusIndicatorView()
//}
