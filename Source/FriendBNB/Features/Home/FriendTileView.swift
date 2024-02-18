//
//  FriendTileView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-01.
//

import SwiftUI

struct FriendTileView: View {
	@State var opened = false
	var property: Property
	
    var body: some View {
		VStack {
			Button(action: {
				
			}, label: {
				VStack(alignment: .leading) {
					Spacer()
					VStack(spacing: 0) {
						Text(property.location.addressTitle)
							.font(.title).fontWeight(.medium)
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(property.location.addressDescription)
							.font(.caption).fontWeight(.light)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					.foregroundColor(.white)
					.padding(Constants.Padding.small)
				}
				.frame(height: 150)
				.frame(maxWidth: .infinity)
				.background(Color.systemGray2)
				.padding(.horizontal, 10)
			})
		}
		.clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

//#Preview {
//    FriendTileView()
//}
