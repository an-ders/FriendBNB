//
//  NewPropertySearchViewModel.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-08.
//

import Foundation
import MapKit

extension NewPropertySearchView {
    @MainActor
    class ViewModel: NSObject, ObservableObject {
        @Published var region = MKCoordinateRegion()
        @Published var results: [AddressSearchResult] = []
        @Published var searchableText = ""
        
        private lazy var localSearchCompleter: MKLocalSearchCompleter = {
            let completer = MKLocalSearchCompleter()
            completer.delegate = self
            return completer
        }()
        
        func searchAddress(_ searchableText: String) {
            guard searchableText.isEmpty == false else { return }
            localSearchCompleter.queryFragment = searchableText
        }
        
        func getPlace(from address: AddressSearchResult) async -> Location? {
            let request = MKLocalSearch.Request()
            let title = address.title
            let subTitle = address.subtitle
            
            request.naturalLanguageQuery = subTitle.contains(title)
            ? subTitle : title + ", " + subTitle
            
            do {
                let response = try await MKLocalSearch(request: request).start()
                if let placemark = response.mapItems.first?.placemark {
                    return Location(placemark: placemark)
                }
            } catch {
                print("ERROR WITH MKLOCALSEARCH")
            }
            return nil
            
        }
    }
}

extension NewPropertySearchView.ViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            results = completer.results.map {
                AddressSearchResult(title: $0.title, subtitle: $0.subtitle)
            }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
