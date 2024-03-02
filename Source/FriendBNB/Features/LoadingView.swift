//
//  LoadingView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-18.
//

import SwiftUI

struct LoadingView: View {
	@State var degreesRotating = 0.0
	
    var body: some View {
		VStack {
			Image(systemName: "rays")
				.resizable()
				.scaledToFit()
				.frame(height: 40)
				.rotationEffect(.degrees(degreesRotating))
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.onAppear {
			  withAnimation(.linear(duration: 1)
				  .speed(0.7).repeatForever(autoreverses: false)) {
					  degreesRotating = 360.0
				  }
		  }
    }
}

//#Preview {
//    LoadingView()
//}
