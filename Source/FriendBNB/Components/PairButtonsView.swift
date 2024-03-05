//
//  PairButtonsView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-10.
//

import SwiftUI

struct PairButtonsView: View {
    var background: Bool = true
    var prevText: String
    var prevAction: () -> Void
    var nextText: String
	var nextCaption: String
    var nextAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    prevAction()
					hideKeyboard()
                }, label: {
                    Text(prevText)
                        .underline()
                        .font(.headline)
                        .foregroundColor(.label)
                })
                
                Spacer()
                
				if !nextText.isEmpty {
					Button(action: {
						nextAction()
						hideKeyboard()
					}, label: {
						VStack {
							Text(nextText)
								.styled(.bodyBold)
							if !nextCaption.isEmpty {
								Text(nextCaption)
									.styled(.caption)
							}
						}
						.padding(.horizontal, 20)
						.padding(.vertical, 8)
						.foregroundColor(.white)
						.background(Color.label)
						.cornerRadius(20)
					})
				}
            }
            .padding(.bottom, Constants.Spacing.small)
            .background {
                Color.white
                    .ignoresSafeArea()
            }
        }
    }
}

//struct PairButtonsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PairButtonsView()
//    }
//}
