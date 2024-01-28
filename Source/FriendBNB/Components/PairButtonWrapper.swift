//
//  PairButtonWrapper.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-26.
//

import SwiftUI

struct PairButtonWrapper<Content: View>: View {
	var buttonPadding: CGFloat = 0
	var prevText: String
	var prevAction: () -> Void
	var nextText: String
	var nextAction: () -> Void
	@ViewBuilder var content: Content
	
    var body: some View {
		ZStack {
			content
			
			VStack {
				Spacer()
				PairButtonsView(prevText: prevText, prevAction: {
					prevAction()
				}, nextText: nextText, nextAction: {
					nextAction()
				})
			}
			.padding(.horizontal, buttonPadding)
		}
    }
}

//#Preview {
//    PairButtonWrapper()
//}
