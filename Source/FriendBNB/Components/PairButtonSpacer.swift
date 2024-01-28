//
//  PairButtonSpacer.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-01-27.
//

import SwiftUI

struct PairButtonSpacer: View {
    var body: some View {
		Rectangle()
			.foregroundColor(.clear)
			.frame(maxWidth: .infinity)
			.frame(height: 75)
    }
}

#Preview {
    PairButtonSpacer()
}
