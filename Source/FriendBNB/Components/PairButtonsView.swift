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
    var nextAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(
                    LinearGradient(gradient: Gradient(colors: [.white, .clear]),
                                   startPoint: .bottom, endPoint: .top)
                )
                .frame(maxWidth: .infinity)
                .frame(height: 25)
            HStack {
                Button(action: {
                    prevAction()
                }, label: {
                    Text(prevText)
                        .underline()
                        .font(.headline)
                        .foregroundColor(.label)
                })
                
                Spacer()
                
                Button(action: {
                    nextAction()
                }, label: {
                    Text(nextText)
                        .font(.title3).fontWeight(.medium)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(Color.label)
                        .cornerRadius(20)
                })
            }
            .padding(.bottom, Constants.Padding.small)
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
