//
//  NewPropertyView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-06.
//

import SwiftUI

enum NewPropertyTabs {
    case info
    case search
    case address
}

struct NewPropertyView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    @Binding var sheetToggle: Bool
    
    var body: some View {
        TabView(selection: $viewModel.currentTab) {
            NewPropertyInfoView(sheetToggle: $sheetToggle,
                                currentTab: $viewModel.currentTab,
                                info: $viewModel.info)
            
            NewPropertySearchView(currentTab: $viewModel.currentTab,
                                  location: $viewModel.location)
                .tag(NewPropertyTabs.search)
            
            NewPropertyAddressView(currentTab: $viewModel.currentTab,
                                   location: $viewModel.location)
                .tag(NewPropertyTabs.address)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
    
    var backgroundColor: Color = Color.init(uiColor: .systemGray6)
}

extension NewPropertyView {
    class ViewModel: ObservableObject {
        @Published var currentTab: NewPropertyTabs = .info
        
        var location: Location?
        var info: NewPropertyInfo?
    }
}

//struct NewPropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyView()
//    }
//}
