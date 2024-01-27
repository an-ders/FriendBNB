//
//  FriendDetailView.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore
import SwiftUIIntrospect

struct FriendDetailView: View {
    @EnvironmentObject var bookingStore: BookingStore
	@EnvironmentObject var propertyManager: PropertyStore
	@Environment(\.dismiss) private var dismiss
	
    @StateObject var viewModel: ViewModel
	@State var showExistingBookingSheet = false
    @State var showNewBookingSheet = false
    
    init(property: Property) {
        self._viewModel = StateObject(wrappedValue: ViewModel(property))
    }
    
    var body: some View {
		PairButtonWrapper(prevText: "Your Bookings", prevAction: {
			showExistingBookingSheet = true
		}, nextText: "Book", nextAction: {
			showNewBookingSheet = true
		}, content: {
			ScrollView {
				VStack {
					Text(viewModel.property.location.addressTitle)
						.font(.title).fontWeight(.medium)
						.frame(maxWidth: .infinity, alignment: .leading)
					Text(viewModel.property.location.addressDescription)
						.font(.headline).fontWeight(.light)
						.frame(maxWidth: .infinity, alignment: .leading)
					Text(String(viewModel.property.rooms))
						.font(.headline).fontWeight(.light)
						.frame(maxWidth: .infinity, alignment: .leading)
					
					TabView {
						Image(systemName: "house")
							.resizable()
							.scaledToFill()
							.background(Color.systemGray5)
						Image(systemName: "house")
							.resizable()
							.scaledToFill()
							.background(Color.systemGray5)
					}
					.onTapGesture {
						print(viewModel.property.bookings)
					}
					.frame(height: 250)
					.cornerRadius(20)
					.tabViewStyle(.page(indexDisplayMode: .always))
					.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
				}
			}
		})
//        .introspectTabBarController { (UITabBarController) in
//            UITabBarController.tabBar.isHidden = true
//        }
        .padding(.horizontal, Constants.Padding.regular)
        
        // Property settings button (...)
//        .toolbar {
//            ToolbarItem(placement: .primaryAction) {
//                OwnedDetailSettingsView(confirmDelete: $viewModel.confirmDelete)
//            }
//        }
        
        // Auxiliary Views
        .alert(isPresented: $viewModel.confirmDelete) {
            Alert(title: Text("Are you sure you want to delete this property?"),
                  primaryButton: .destructive(Text("Delete")) {
                Task {
                    await propertyManager.deleteProperty(id: viewModel.property.id, type: .owned)
                }
            },
                  secondaryButton: .default(Text("Cancel")))
        }
        
        //.sync($bookingStore.showFriendExistingBookingSheet, with: $showPersonalBookingSheet)
        .sheet(isPresented: $showExistingBookingSheet) {
            FriendExistingBookingView(property: viewModel.property)
                .interactiveDismissDisabled()
        }
        
        //.sync($bookingStore.showFriendNewBookingSheet, with: $showNewBookingSheet)
        .sheet(isPresented: $showNewBookingSheet) {
			FriendNewBookingView(property: viewModel.property)
                .interactiveDismissDisabled()
        }
        
        // When the property gets deleted in Firestore "exit" gets toggled
        .onChange(of: viewModel.exit) { _ in
            dismiss()
            Task {
                await propertyManager.fetchProperties(.owned)
            }
        }
        .onAppear {
            viewModel.subscribe()
        }
        .onDisappear {
            viewModel.unsubscribe()
        }
    }
}

extension FriendDetailView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var property: Property
        @Published var exit: Bool = false
        @Published var confirmDelete: Bool = false
        @Published var createBooking: Bool = false
        var listener: ListenerRegistration?

        init(_ property: Property) {
            self.property = property
        }
        
        func subscribe() {
            print("Adding listener in DETAIL VIEW")
            let db = Firestore.firestore()
            self.listener = db.collection("Properties").document(property.id)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }

                    if let newData = document.data() {
                        print("Updating data DETAIL VIEW")
                        self.property = Property(id: self.property.id, data: newData)

                    } else {
                        self.exit.toggle()
                    }
                }
        }
        
        func unsubscribe() {
            print("Removing listener from DETAIL VIEW")
            self.listener?.remove()
        }
    }
}

//struct PropertyDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PropertyDetail()
//    }
//}
