//
//  DetailSheetTitle.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-20.
//

import SwiftUI

struct DetailSheetTitle: View {
	@Environment(\.dismiss) private var dismiss
	
	var title: String
	var showDismiss: Bool = true
	
    var body: some View {
		HStack(alignment: .center) {
			Text(title)
				.styled(.title)
				.fillLeading()
				.padding(.vertical, Constants.Spacing.small)
			
			if showDismiss {
				Button(action: {
					dismiss()
				}, label: {
					Image(systemName: "x.circle.fill")
						.resizable()
						.scaledToFit()
						.frame(height: 20)
						.foregroundStyle(Color.systemGray3)
				})
			}
		}
    }
}

//#Preview {
//    DetailSheetTitle()
//}
