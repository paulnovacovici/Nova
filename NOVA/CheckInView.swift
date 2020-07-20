//
//  StoreForm.swift
//  NOVA
//
//  Created by pnovacov on 7/11/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

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
    
    func canSubmit() -> Bool {
        return store.count > 0 && images.count > 0
    }
}

struct CheckInView: View {
    @EnvironmentObject var clockedInTimer : TimerManager
    @ObservedObject var storeForm = StoreForm()
    @State var show = false
    
    var body: some View {
        NavigationView {
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
                
                Section {
                    Button(action: {
                        // Execute POST request to server.
                        self.storeForm.reset()
                    }) {
                        Text("Submit")
                    }.disabled(!self.storeForm.canSubmit())
                }
            }
                .navigationBarTitle("Check-in")
                .navigationBarItems(leading: ClockInTimeView().environmentObject(clockedInTimer))
        }
    }
}

struct StoreForm_Previews: PreviewProvider {
    static var previews: some View {
             CheckInView()
    }
}
