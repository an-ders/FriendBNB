//
//  Image.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-03-04.
//

import Foundation
import SwiftUI

extension Image {
	func size(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
		self
			.resizable()
			.scaledToFit()
			.frame(width: width, height: height)
   }
}
