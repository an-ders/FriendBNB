//
//  ToggleInfoDetail.swift
//  FriendBNB
//
//  Created by Anders Tai on 2024-02-25.
//

import SwiftUI

struct ToggleInfoDetail: View {
	@Binding var toggle: Bool
	var title: String
	var text: String
	
    var body: some View {
		Toggle(title, isOn: $toggle)
			.styled(.bodyBold)
			.padding(.trailing, 4)
		
		if toggle {
			Text(text)
				.styled(.body)
				.fillLeading()
		}
    }
}

//#Preview {
//    ToggleInfoDetail()
//}
