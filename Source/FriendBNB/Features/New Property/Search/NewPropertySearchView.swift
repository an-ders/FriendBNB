//
//  AddressSearchView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-07.
//

import SwiftUI
import MapKit

struct NewPropertySearchView: View {
    @EnvironmentObject var newPropertyManager: NewPropertyManager
    @StateObject var viewModel = NewPropertySearchView.ViewModel()
    
    @FocusState private var isFocusedTextField: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                TextField("Type address", text: $viewModel.searchableText)
                    .padding(.vertical)
                    .autocorrectionDisabled()
                    .focused($isFocusedTextField)
                    .font(.title)
                    .onReceive(
                        viewModel.$searchableText.debounce(
                            for: .seconds(1),
                            scheduler: DispatchQueue.main
                        )
                    ) {
                        viewModel.searchAddress($0)
                    }
                    .background(Color.init(uiColor: .systemBackground))
                    .overlay {
                        ClearButton(text: $viewModel.searchableText)
                            .padding(.top, 8)
                    }
                    .onAppear {
                        isFocusedTextField = true
                    }

                List(viewModel.results) { address in
                    AddressRow(address: address) {
                        Task { @MainActor in
                            if let location = await viewModel.getPlace(from: address) {
                                newPropertyManager.location = location
                                
                                withAnimation {
                                    newPropertyManager.currentTab = .address
                                }
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    //.listRowBackground(backgroundColor)
                }
                .frame(maxWidth: .infinity)
                .listStyle(.inset)
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                Rectangle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [.white, .clear]),
                                       startPoint: .bottom, endPoint: .top)
                        )
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                
                Rectangle()
                    .fill(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
            
            }
            
            VStack {
                Spacer()
                PairButtonsView(prevText: "Back", prevAction: {
                    withAnimation {
                        newPropertyManager.currentTab = .info
                    }
                }, nextText: "Skip", nextAction: {
                    newPropertyManager.location = Location()
                    
                    withAnimation {
                        newPropertyManager.currentTab = .address
                    }
                })
            }
        }
        .padding(.horizontal, Constants.Padding.regular)
    }
}

struct AddressRow: View {
    let address: AddressSearchResult
    let action: () ->  Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading) {
                Text(address.title)
                Text(address.subtitle)
                    .font(.caption)
            }
        }
        .padding(.bottom, 2)
    }
}

struct ClearButton: View {
    @Binding var text: String
    
    var body: some View {
        if text.isEmpty == false {
            HStack {
                Spacer()
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                }
                .foregroundColor(.secondary)
            }
        } else {
            EmptyView()
        }
    }
}
