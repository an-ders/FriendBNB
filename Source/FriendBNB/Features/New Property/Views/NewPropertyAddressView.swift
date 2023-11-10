//
//  NewPropertyAddressView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-09.
//

import SwiftUI

struct NewPropertyAddressView: View {
    @Binding var currentTab: NewPropertyTabs
    @Binding var location: Location?
    
    var body: some View {
        VStack {
            PairButtonsView(prevText: "Back", prevAction: {
                withAnimation {
                    currentTab = .search
                }
            }, nextText: "Next", nextAction: {
                
            })
        }
    }
}

//struct NewPropertyAddressView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyAddressView()
//    }
//}
