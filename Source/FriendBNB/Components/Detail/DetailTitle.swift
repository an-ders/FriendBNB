//
//  DetailTitle.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-08.
//

import SwiftUI

struct DetailTitle: View {
	var title: String
	
    var body: some View {
		Text(title)
			.styled(.title2)
			.fillLeading()
    }
}

#Preview {
	DetailTitle(title: "Detail Title")
}
