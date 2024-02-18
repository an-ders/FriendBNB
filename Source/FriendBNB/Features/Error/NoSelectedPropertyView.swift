//
//  NoSelectedPropertyView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-28.
//

import SwiftUI

struct NoSelectedPropertyView: View {
	@Environment(\.dismiss) private var dismiss
	
    var body: some View {
		VStack {
			Image(systemName: "questionmark.circle.fill")
				.resizable()
				.scaledToFit()
				.frame(width: 50)
			Text("Sorry something went wrong")
				.font(.title).fontWeight(.medium)
			
			Button(action: {
				dismiss()
			}, label: {
				Text("Exit")
					.font(.headline)
					.padding(.horizontal, 16)
					.padding(.vertical, 8)
					.foregroundColor(.white)
					.background(Color.systemGray3)
					.cornerRadius(10)
			})
		}
    }
}

#Preview {
    NoSelectedPropertyView()
}
