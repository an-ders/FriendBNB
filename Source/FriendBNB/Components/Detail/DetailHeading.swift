//
//  DetailHeading.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-08.
//

import SwiftUI

struct DetailHeading: View {
	var title: String
    var body: some View {
		Text(title)
			.styled(.bodyBold)
			.fillLeading()
			.foregroundStyle(Color.systemGray)
    }
}

#Preview {
	DetailHeading(title: "TEST 123")
}
