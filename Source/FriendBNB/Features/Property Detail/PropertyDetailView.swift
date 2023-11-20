//
//  PropertyDetail.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore
import SwiftUIIntrospect

struct PropertyDetailView: View {
    @StateObject var bookingManager: BookingManager
    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var yourPropertyManager: YourPropertyManager
    
    @State var showNewBookingSheet = false
    @State var showExistingBookingSheet = false
    
    init(property: Property) {
        self._viewModel = StateObject(wrappedValue: ViewModel(property))
        self._bookingManager = StateObject(wrappedValue: BookingManager(property))
    }
    
    var body: some View {
        ZStack {
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
            
            VStack {
                Spacer()
                PairButtonsView(prevText: "Your Bookings", prevAction: {
                    bookingManager.showExistingBookingSheet = true
                }, nextText: "New Booking", nextAction: {
                    bookingManager.showNewBookingSheet = true
                })
            }
        }
//        .introspectTabBarController { (UITabBarController) in
//            UITabBarController.tabBar.isHidden = true
//        }
        .padding(.horizontal, Constants.Padding.regular)
        
        // Property settings button (...)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                PropertyDetailSettingsView(confirmDelete: $viewModel.confirmDelete)
            }
        }
        
        // Auxiliary Views
        .alert(isPresented: $viewModel.confirmDelete) {
            Alert(title: Text("Are you sure you want to delete this property?"),
                  primaryButton: .destructive(Text("Delete")) {
                Task {
                    await yourPropertyManager.deleteProperty(id: viewModel.property.id)
                }
            },
                  secondaryButton: .default(Text("Cancel")))
        }
        
        .sync($bookingManager.showNewBookingSheet, with: $showNewBookingSheet)
        .sheet(isPresented: $showNewBookingSheet) {
            NewBookingView()
                .environmentObject(bookingManager)
        }
        
        .sync($bookingManager.showExistingBookingSheet, with: $showExistingBookingSheet)
        .sheet(isPresented: $showExistingBookingSheet) {
            ExistingBookingView()
                .environmentObject(bookingManager)
        }
        
        .environmentObject(bookingManager)
        // When the property gets deleted in Firestore "exit" gets toggled
        .onChange(of: viewModel.exit) { _ in
            self.presentationMode.wrappedValue.dismiss()
            Task {
                await yourPropertyManager.fetchProperties()
            }
        }
        
        .onAppear {
            viewModel.subscribe()
            bookingManager.subscribe()
        }
        // Unsubscribe
        .onDisappear {
            viewModel.unsubscribe()
            bookingManager.unsubscribe()
        }
    }
}

extension PropertyDetailView {
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
                        self.property.updateData(newData)

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
