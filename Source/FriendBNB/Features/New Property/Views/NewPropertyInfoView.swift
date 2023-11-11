//
//  NewPropertyInfoView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-08.
//

import SwiftUI

struct NewPropertyInfoView: View {
    @Binding var showSheet: Bool
    @Binding var currentTab: NewPropertyTabs
    @Binding var info: NewPropertyInfo?
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: Constants.Spacing.regular) {
            Text("Some basic details about your place")
                .font(.largeTitle).fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Constants.Spacing.small)
            
            CustomStepperView(text: "Rooms", value: $viewModel.rooms, min: 1)
            Divider()
            CustomStepperView(text: "People", value: $viewModel.people, min: 1)
        
            Spacer()
            
            PairButtonsView(prevText: "Close", prevAction: {
                showSheet = false
            }, nextText: "Next", nextAction: {
                info = viewModel.getInfo()
                
                withAnimation {
                    currentTab = .search
                }
            })
            
        }
        .padding(.horizontal, Constants.Padding.regular)
        .padding(.top, Constants.Padding.regular)
    }
}

extension NewPropertyInfoView {
    class ViewModel: ObservableObject {
        @Published var rooms: Int = 1
        @Published var people: Int = 4
        @Published var error: String?
        
        func getInfo() -> NewPropertyInfo? {
            return NewPropertyInfo(rooms: self.rooms, people: self.people)
        }
    }
}

//struct NewPropertyInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyInfoView()
//    }
//}
