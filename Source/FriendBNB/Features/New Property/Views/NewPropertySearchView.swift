//
//  AddressSearchView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-07.
//

import SwiftUI
import MapKit

struct NewPropertySearchView: View {
    @EnvironmentObject var propertyStore: PropertyStore
	@Environment(\.dismiss) private var dismiss

	@Binding var currentTab: NewPropertyTabs
	@ObservedObject var location: Location
	
    @StateObject var viewModel = NewPropertySearchView.ViewModel()
    @FocusState private var isFocusedTextField: Bool
    
    var body: some View {
		PairButtonWrapper(buttonSpacing: Constants.Spacing.regular, prevText: "Cancel", prevAction: {
			back()
		}, nextText: "", nextAction: {
			
		}, content: {
			VStack(alignment: .leading, spacing: 0) {
				HStack(alignment: .center) {
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
						.frame(maxWidth: .infinity, alignment: .leading)
						.onAppear {
							isFocusedTextField = true
						}
						.padding(.leading, Constants.Spacing.regular)
						.padding(.trailing, Constants.Spacing.small)
					
					ClearButton(text: $viewModel.searchableText)
						.padding(.trailing, Constants.Spacing.regular)
				}
				.background(Color.init(uiColor: .systemGray6))

				List(viewModel.results) { address in
					AddressRow(address: address) {
						Task { @MainActor in
							if let placemark = await viewModel.getPlace(from: address) {
								self.location.update(placemark: placemark)
								
								next()
								hideKeyboard()
							}
						}
					}
					.listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
				}
				.frame(maxWidth: .infinity)
				.listStyle(.inset)
				.zIndex(5)
			}
		})
        
    }
	
	func next() {
		withAnimation {
			self.currentTab = .address
		}
	}
	
	func back() {
		dismiss()
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
			.padding(.horizontal, Constants.Spacing.regular)
        }
        .padding(.bottom, 2)
    }
}

struct ClearButton: View {
    @Binding var text: String
    
    var body: some View {
        if text.isEmpty == false {
			Button {
				text = ""
			} label: {
				Image(systemName: "multiply.circle.fill")
					.foregroundColor(.black.opacity(0.7))
			}
			.foregroundColor(.secondary)
        } else {
            EmptyView()
        }
    }
}
