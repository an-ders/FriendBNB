//
//  PaymentTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-05.
//

import SwiftUI

struct PaymentTileView: View {
	var type: PaymentType
    var body: some View {
		HStack {
			Image(systemName: type.image)
				.size(height: 30)
			Text(type.rawValue)
				.styled(.bodyBold)
				.fillLeading()
		}
		.foregroundStyle(Color.black)
		.padding(.horizontal, Constants.Spacing.large)
		.padding(.vertical, Constants.Spacing.medium)
		.overlay(
			RoundedRectangle(cornerRadius: 5)
				.stroke(Color.systemGray, lineWidth: 1)
		)
		.contentShape(Rectangle())
    }
}

//#Preview {
//    PaymentTileView()
//}
