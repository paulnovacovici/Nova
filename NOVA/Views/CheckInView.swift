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

class StoreForm: ObservableObject {
    @Published var store = ""
    @Published var managerIn = false
    @Published var spokeTo = ""
    @Published var shelfStocked = false
    @Published var arrivalTime = Date()
    @Published var needs = ""
    @Published var images: [UIImage] = []
    
    func reset() {
        store = ""
        managerIn = false
        spokeTo = ""
        shelfStocked = false
        arrivalTime = Date()
        needs = ""
        images = []
    }
    
    func imagesMetaData(imageURLs images: [String]) -> StoreCheckIn {
        return StoreCheckIn(store: self.store, manager: self.spokeTo, arrivalTime: self.arrivalTime, needs: self.needs, shelfStocked: self.shelfStocked, images: images, userId: Auth.auth().currentUser!.uid)
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
                        let data = self.imagesMetaData(imageURLs: imageURLs)
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
    
    func canSubmit() -> Bool {
        return store.count > 0 && images.count > 0
    }
}

struct CheckInView: View {
    @EnvironmentObject var locationManager : LocationManager
    @EnvironmentObject var session: SessionStore
    @ObservedObject var storeForm = StoreForm()
    @State var show = false
    @State var isLoading = false
    @State var showAlert = false
    @State var alertText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        TextField("Store Name", text: $storeForm.store)
                        DatePicker("Arrival time", selection: $storeForm.arrivalTime)
                    }
                    
                    Section {
                        Toggle(isOn: $storeForm.managerIn) {
                            Text("Is the manager there?")
                        }
                        
                        if storeForm.managerIn {
                            TextField("Manager Name", text: $storeForm.spokeTo)
                        }
                        
                        Toggle(isOn: $storeForm.shelfStocked) {
                            Text("Is the shelf stocked?")
                        }
                        
                        TextField("Does anything need to be ordered?", text: $storeForm.needs)
                    }
                    
                    if !self.storeForm.images.isEmpty{
                        Section {
                            PhotoRow(photos: self.storeForm.images)
                        }.listRowInsets(EdgeInsets())
                    }
                    
                    Section {
                        Button(action: {
                            
                            self.storeForm.images.removeAll()

                            self.show.toggle()
                            
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
                        .sheet(isPresented: $show) {
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
            .navigationBarTitle("Check-in")
            .navigationBarItems(
                leading: TimerView().environmentObject(locationManager),
                trailing: Button(action: upload) {
                            Text("Submit")
                        }.disabled(!self.storeForm.canSubmit()))
        }
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
