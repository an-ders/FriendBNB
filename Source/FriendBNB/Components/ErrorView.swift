//
//  ErrorView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-25.
//

import SwiftUI

struct ErrorView: View {
	var error: String
	
    var body: some View {
		if error.isEmpty {
			EmptyView()
		} else {
			Text(error)
				.font(.footnote)
				.foregroundColor(Color.systemRed)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.top, Constants.Spacing.small)
		}
    }
}
