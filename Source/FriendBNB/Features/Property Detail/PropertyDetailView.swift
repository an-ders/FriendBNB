//
//  PropertyDetail.swift
//  FriendBNB
//
//  Created by Anders Tai on 2023-11-11.
//

import SwiftUI
import FirebaseFirestore

struct PropertyDetailView: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var homeManager: HomeManager

    init(property: Property) {
        self._viewModel = StateObject(wrappedValue: ViewModel(property))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text(viewModel.property.location.addressTitle)
                        .font(.title).fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(viewModel.property.location.addressDescription)
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
                    
                    Button(action: {
                        viewModel.createBooking = true
                    }, label: {
                        Text("Start Booking")
                            .font(.title3).fontWeight(.medium)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .foregroundColor(.white)
                            .background(Color.label)
                            .cornerRadius(20)
                    })
                }
            }
        }
        .onChange(of: viewModel.exit) { _ in
            self.presentationMode.wrappedValue.dismiss()
            Task {
                await homeManager.fetchProperties()
            }
        }
        .padding(.horizontal, Constants.Padding.regular)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                PropertyDetailSettingsView(confirmDelete: $viewModel.confirmDelete)
            }
        }
        .alert(isPresented: $viewModel.confirmDelete) {
            Alert(title: Text("Are you sure you want to delete this property?"),
                  primaryButton: .destructive(Text("Delete")) {
                Task {
                    await homeManager.deleteProperty(id: viewModel.property.id)
                }
            },
                  secondaryButton: .default(Text("Cancel")))
        }
        .sheet(isPresented: $viewModel.createBooking) {
            BookingView(property: viewModel.property)
        }
    }
}

extension PropertyDetailView {
    class ViewModel: ObservableObject {
        @Published var property: Property
        @Published var exit: Bool = false
        @Published var confirmDelete: Bool = false
        @Published var createBooking: Bool = false

        init(_ property: Property) {
            self.property = property
            
            let db = Firestore.firestore()
            db.collection("Properties").document(property.id)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    
                    if let newData = document.data() {
                        self.property = Property(id: property.id, data: newData)
                    } else {
                        self.exit.toggle()
                    }
                }
        }
        
        
    }
}

//struct PropertyDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PropertyDetail()
//    }
//}
