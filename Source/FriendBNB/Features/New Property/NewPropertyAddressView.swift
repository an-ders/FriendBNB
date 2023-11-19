//
//  NewPropertyAddressView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-09.
//

import SwiftUI

struct NewPropertyAddressView: View {
    @EnvironmentObject var homeManager: HomeManager
    @EnvironmentObject var newPropertyManager: NewPropertyManager
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Confirm the address")
                .font(.largeTitle).fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Constants.Spacing.regular)

            StyledFloatingTextField(text: $viewModel.streetName, prompt: "Street Name", error: $viewModel.streetNameError)
            StyledFloatingTextField(text: $viewModel.streetNumber, prompt: "Street Number", error: $viewModel.streetNumberError)
            StyledFloatingTextField(text: $viewModel.city, prompt: "City", error: $viewModel.cityError)
            StyledFloatingTextField(text: $viewModel.state, prompt: "State", error: $viewModel.stateError)
            StyledFloatingTextField(text: $viewModel.zipCode, prompt: "Zip Code", error: $viewModel.zipCodeError)
            StyledFloatingTextField(text: $viewModel.country, prompt: "Country", error: $viewModel.countryError)

            Spacer()
            
            PairButtonsView(prevText: "Back", prevAction: {
                withAnimation {
                    newPropertyManager.currentTab = .search
                }
            }, nextText: "Confirm", nextAction: {
                if viewModel.validAddress() {
                    Task {
                        let newId = await newPropertyManager.addDocument()
                        await homeManager.addProperty(newId)
                        homeManager.showNewPropertySheet = false
                    }
                }
            })
        }
        .padding(.horizontal, Constants.Padding.regular)
        .padding(.top, Constants.Padding.regular)
        .onAppear {
            viewModel.syncLocation(newPropertyManager.location)
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
        
        @Published var streetNameError: String = ""
        @Published var streetNumberError: String = ""
        @Published var cityError: String = ""
        @Published var stateError: String = ""
        @Published var zipCodeError: String = ""
        @Published var countryError: String = ""
        
        func syncLocation(_ location: Location) {
            streetName = location.streetName
            streetNumber = location.streetNumber
            city = location.city
            state = location.state
            zipCode = location.zipCode
            country = location.country
        }
        
        func validAddress() -> Bool {
            let emptyError = "Field cannot be empty."
            
            if streetName.isEmpty {
                streetNameError = emptyError
            }
            if streetNumber.isEmpty {
                streetNumberError = emptyError
            }
            if city.isEmpty {
                cityError = emptyError
            }
            if state.isEmpty {
                stateError = emptyError
            }
            if zipCode.isEmpty {
                zipCodeError = emptyError
            }
            if country.isEmpty {
                countryError = emptyError
            }
            
            return !country.isEmpty || !zipCode.isEmpty || !state.isEmpty || !city.isEmpty || !streetNumber.isEmpty || !streetName.isEmpty
        }
    }
}

//struct NewPropertyAddressView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPropertyAddressView()
//    }
//}
