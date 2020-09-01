//
//  StoreForm.swift
//  NOVA
//
//  Created by pnovacov on 7/11/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class StoreFormViewModel: ObservableObject {
    @Published var managerIn = false
    @Published var spokeTo = ""
    @Published var shelfStocked = false
    @Published var arrivalTime = Date()
    @Published var needs = ""
    @Published var images: [UIImage] = []
    @Published var storeIndex = 0
    @Published var brandIndex = 0
    
    // TODO: Get these from firebase
    let stores = mockStoreData
    let brands = mockBrandData
    
    var brand: BrandDTO {
        return brands[brandIndex]
    }
    
    func reset() {
        storeIndex = 0
        brandIndex = 0
        managerIn = false
        spokeTo = ""
        shelfStocked = false
        arrivalTime = Date()
        needs = ""
        images = []
    }
    
    func createStoreFormORM(imageURLs images: [String]) -> StoreCheckInDTO {
        let storeName = self.stores[self.storeIndex].name
        let address = self.stores[self.storeIndex].fullAddress ?? ""
        let brandName = self.brands[self.brandIndex].name
        let brandEmail = self.brands[self.brandIndex].email
        return StoreCheckInDTO(store: storeName, manager: self.spokeTo, arrivalTime: self.arrivalTime, needs: self.needs, shelfStocked: self.shelfStocked, images: images, userId: Auth.auth().currentUser!.uid, address: address, brandName: brandName, brandEmail: brandEmail)
    }
    
    func submit(completion: @escaping (String?) -> ()) {
        var imageURLs: [String] = []
        
        for image in images {
            guard let data = image.jpegData(compressionQuality: 1.0) else {
                completion("Can't get image data please try again")
                return
            }

            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference()
                .child(FirebaseKeys.CollectionPath.images)
                .child(imageName)
            
            storageRef.putData(data, metadata: nil) { (metadata, error) in
                if let err = error {
                    completion(err.localizedDescription)
                    return
                }
                
                storageRef.downloadURL { (url, err) in
                    if let err = err {
                        completion(err.localizedDescription)
                        return
                    }
                    
                    guard let url = url else {
                        completion("Something unexpectedly went wrong")
                        return
                    }
                    
                    imageURLs.append(url.absoluteString)
                    
                    if imageURLs.count == self.images.count {
                        let data = self.createStoreFormORM(imageURLs: imageURLs)
                        let dataRef = FirestoreReferenceManager.root.collection(FirebaseKeys.CollectionPath.checkIns).document()
                        do {
                            try dataRef.setData(from: data) { (err) in
                                if let err = err {
                                    completion(err.localizedDescription)
                                    return
                                }
                                
                                completion(nil)
                            }

                        } catch let error {
                            completion(error.localizedDescription)
                        }
                    }
                }
            }

        }
    }
    
    func canNext() -> Bool {
        return storeIndex > 0 && brandIndex > 0
    }
    
    func canSubmit() -> Bool {
        return storeIndex > 0 && images.count > 0 && brandIndex > 0
    }
}


struct CheckInView: View {
    @EnvironmentObject var locationManager : LocationManager
    @EnvironmentObject var session: SessionStore
    @ObservedObject var storeForm = StoreFormViewModel()
 
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        Picker(selection: $storeForm.storeIndex, label: Text("Store Name")) {
                            ForEach(0 ..< mockStoreData.count, id: \.self) { i in
                                VStack(alignment: .leading) {
                                    Text(mockStoreData[i].name)
                                    mockStoreData[i].fullAddress.map { address in
                                        Text(address)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                                        .lineLimit(1)
                                    }
                                }.tag(i)
                            }
                        }
                        
                        Picker(selection: $storeForm.brandIndex, label: Text("Brand Name")) {
                            ForEach(0 ..< mockBrandData.count, id: \.self) { i in
                                VStack(alignment: .leading) {
                                    Text(mockBrandData[i].name)
                                }.tag(i)
                            }
                        }
                        
                        DatePicker("Arrival time", selection: $storeForm.arrivalTime)
                    }
                }
            }
            .navigationBarTitle("Check-in")
            .navigationBarItems(
                leading: cancelButton,
                trailing: nextButton)
        }
    }
    
    var cancelButton: some View {
        Button(action: {
            self.storeForm.reset()
        }) {
            Text("Cancel")
        }
    }
    
    var nextButton: some View {
        NavigationLink(destination: StoreBrandInfoView(storeForm: self.storeForm)){
            Text("Next")
        }.disabled(!self.storeForm.canNext())
    }
    
}

struct StoreBrandInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var storeForm: StoreFormViewModel
    @State var showNewOrderView = false
    @State var isLoading = false
    @State var orders: [OrderViewModel] = []
    @State var showImagePickerView = false
    @State var showAlert = false
    @State var alertText = ""

    var body: some View {
        ZStack {
            Form {
                Section(header: Text("ORDERS")) {
                    ForEach(0 ..< orders.count, id: \.self) { i in
                        OrderRow(order: self.orders[i])
                    }
                    Button(action: {
                        self.showNewOrderView.toggle()
                    }) {
                        HStack {
                            Text("Add Order")
                            Image(systemName: "plus")
                        }
                    }.sheet(isPresented: $showNewOrderView) {
                        OrderView(brand: self.storeForm.brand, orders: self.$orders)
                    }
                }
                
                Section(header: Text("ADDITIONAL INFO")) {
                    Toggle(isOn: $storeForm.managerIn) {
                        Text("Is the manager there?")
                    }
                    
                    TextField("Who did you speak to?", text: $storeForm.spokeTo)

                    
                    Toggle(isOn: $storeForm.shelfStocked) {
                        Text("Is the shelf stocked?")
                    }
                }
                
                
                
                
                Section(header: Text("PHOTOS")) {
                    if !self.storeForm.images.isEmpty{
                        Section {
                            PhotoRow(photos: self.storeForm.images)
                        }.listRowInsets(EdgeInsets())
                    }
                    
                    Button(action: {
                        
                        self.storeForm.images.removeAll()

                        self.showImagePickerView.toggle()
                        
                    }) {
                        HStack{
                            if self.storeForm.images.isEmpty{
                                Text("Select Photos")
                            } else {
                                Text("Reselect Photos")
                            }
                            Image(systemName: "photo")
                        }
                    }
                    .sheet(isPresented: $showImagePickerView) {
                        TPImagePicker(images: self.$storeForm.images)
                    }
                }
            }
            if self.isLoading {
                LoadingView()
            }
        }
        
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertText))
        }
        .navigationBarTitle("Check In", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: cancelButton, trailing: submitButton)
    }
    
    var cancelButton: some View {
        Button(action: {
            self.storeForm.reset()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
        }
    }
    
    var submitButton: some View {
        Button(action: upload) {
            Text("Submit")
        }.disabled(!self.storeForm.canSubmit())
    }
    
    func showAlertMessage(_ message: String) {
        self.alertText = message
        self.showAlert = true
    }
    
    func upload() {
        self.isLoading = true
        self.storeForm.submit { (err) in
            if let err = err {
                self.showAlertMessage(err)
            }
            
            self.storeForm.reset()
            self.isLoading = false
        }
    }
}

struct OrderRow: View {
    @ObservedObject var order: OrderViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(order.item)
                Text(order.SKU)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                    .lineLimit(1)
            }
            Spacer()
            Text("\(order.numCases) cases")
        }
    }
}

struct PhotoRow : View {
    var photos: [UIImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(alignment: .top, spacing: 0){
                
                ForEach(self.photos, id: \.self){photo in
                    
                    Image(uiImage: photo)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
                    .padding(.leading, 15)
                }
            }
        }.frame(height: 185)
    }
}

struct StoreForm_Previews: PreviewProvider {
    static var previews: some View {
             CheckInView().environmentObject(LocationManager())
    }
}
