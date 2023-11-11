//
//  NewPropertyAddressView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-09.
//

import SwiftUI
import FloatingPromptTextField

struct NewPropertyAddressView: View {
    @Binding var currentTab: NewPropertyTabs
    @Binding var location: Location
    
    var confirmAction: () -> Void
    
    @StateObject var viewModel: NewPropertyAddressView.ViewModel
    
    init(currentTab: Binding<NewPropertyTabs>, location: Binding<Location>, confirmAction: @escaping () -> Void) {
        self._currentTab = currentTab
        self._location = location
        self._viewModel = StateObject(wrappedValue: ViewModel())
        self.confirmAction = confirmAction
    }
    
    var body: some View {
        VStack {
            Text("Confirm the address")
                .font(.largeTitle).fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Constants.Spacing.small)

            FloatingPromptTextField(text: $viewModel.streetName, prompt: Text("Street Name"))
            FloatingPromptTextField(text: $viewModel.streetNumber, prompt: Text("Street Number"))
            FloatingPromptTextField(text: $viewModel.city, prompt: Text("City"))
            FloatingPromptTextField(text: $viewModel.state, prompt: Text("State"))
            FloatingPromptTextField(text: $viewModel.zipCode, prompt: Text("Zip Code"))
            FloatingPromptTextField(text: $viewModel.country, prompt: Text("Country"))

            Spacer()
            
            PairButtonsView(prevText: "Back", prevAction: {
                withAnimation {
                    currentTab = .search
                }
            }, nextText: "Confirm", nextAction: {
                confirmAction()
            })
        }
        .padding(.horizontal, Constants.Padding.regular)
        .padding(.top, Constants.Padding.regular)
        .onAppear {
            viewModel.syncLocation(location)
        }
    }
}

fileprivate func getLocales() -> [Country] {
    let locales = Locale.isoRegionCodes
        .filter { $0 != "United States"}
        .compactMap { Country(id: $0, name: Locale.current.localizedString(forRegionCode: $0) ?? $0)}
    return [Country(id: "US", name: Locale.current.localizedString(forRegionCode: "US") ?? "United States")] + locales
}

fileprivate struct Country {
    var id: String
    var name: String
}

extension NewPropertyAddressView {
    class ViewModel: ObservableObject {
        @Published var streetName: String = ""
        @Published var streetNumber: String = ""
        @Published var city: String = ""
        @Published var state: String = ""
        @Published var zipCode: String = ""
        @Published var country: String = ""
        
        func syncLocation(_ location: Location) {
            streetName = location.streetName
            streetNumber = location.streetNumber
            city = location.city
            state = location.state
            zipCode = location.zipCode
            country = location.country
        }
    }
}

//struct NewPropertyAddressView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyAddressView()
//    }
//}
