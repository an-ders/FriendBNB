//
//  DetailParagraph.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-08.
//

import SwiftUI

struct DetailParagraph: View {
	var title: String
	var image: String
	var description: String
	
    var body: some View {
		VStack(alignment: .leading) {
			Text(title)
				.styled(.bodyBold)
				.fillLeading()
				.foregroundStyle(Color.systemGray)
			
			HStack(alignment: .top) {
				Image(systemName: image)
					.resizable()
					.scaledToFit()
					.frame(width: 25)
				Text(description)
					.styled(.body)
			}
		}
    }
}

#Preview {
	DetailParagraph(title: "PERSON", image: "person", description: "test description that happens to be too long for this screen")
}
