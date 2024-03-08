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
		HStack(spacing: Constants.Spacing.medium) {
			DetailTitle(title: title)
			
			if showDismiss {
				Button(action: {
					dismiss()
				}, label: {
					Image(systemName: "xmark")
						.size(height: 20)
						.foregroundStyle(Color.systemGray3)
				})
			}
		}
    }
}

//#Preview {
//    DetailSheetTitle()
//}
