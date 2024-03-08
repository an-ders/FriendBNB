//
//  Background + Modifiers.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-05.
//

import Foundation
import SwiftUI

struct DarkWindow: ViewModifier {
	func body(content: Content) -> some View {
		content
			.background(.ultraThinMaterial.opacity(0.4))
			.background(Color.black.opacity(0.6))
	}
}

extension View {
	func darkWindow() -> some View {
		modifier(DarkWindow())
	}
}
