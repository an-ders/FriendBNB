//
//  ErrorView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-25.
//

import SwiftUI

struct ErrorView: View {
	@Binding var error: String
	
    var body: some View {
		Text(error)
			.font(.footnote)
			.foregroundColor(Color.systemRed)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.top, Constants.Padding.small)
    }
}
