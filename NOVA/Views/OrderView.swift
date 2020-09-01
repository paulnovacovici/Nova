//
//  OrderView.swift
//  NOVA
//
//  Created by pnovacov on 8/26/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

class OrderViewModel: ObservableObject {
    @Published var itemSelection: Int = 0
    @Published var SKUSelection: Int = 0
    @Published var placementTypeSelection: Int = 0
    @Published var numCases: String = ""
    @Published var expectedDeliveryDate: Date = Date()
    var brand: BrandDTO
    
    var brandItems: [Item] {
        return [Item(name: "None", SKUs: [])] + brand.items
    }
    var itemSKUs: [String] {
        return ["None"] + brandItems[itemSelection].SKUs
    }
    
    let placementTypes = ["None", "New Distribution", "Restaurant", "Banquests", "Rooms", "Other"]
    
    var item: String {
        brandItems[itemSelection].name
    }
    
    var SKU: String {
        itemSKUs[SKUSelection]
    }
    
    var placement: String {
        placementTypes[placementTypeSelection]
    }
    
    init(brand: BrandDTO) {
        self.brand = brand
    }
    
    func canSubmit() -> Bool {
        guard let numCases = Int(numCases) else { return false }
        return itemSelection > 0 &&
        SKUSelection > 0 &&
        placementTypeSelection > 0 &&
        numCases > 0
    }
    
}

struct OrderView: View {
    @ObservedObject var orderModel: OrderViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var orders: [OrderViewModel]
    
    init(brand: BrandDTO, orders: Binding<[OrderViewModel]>) {
        self.orderModel = OrderViewModel(brand: brand)
        self._orders = orders
    }
    

    var body: some View {
        NavigationView {
            Form {
                Picker(selection: $orderModel.itemSelection.onChange(itemSelectionChanged), label: Text("Item")) {
                    ForEach(0 ..< orderModel.brandItems.count, id: \.self) { i in
                        Text(self.orderModel.brandItems[i].name)
                            .tag(i)
                    }
                }
                
                Picker(selection: $orderModel.SKUSelection, label: Text("SKU")) {
                    ForEach(0 ..< orderModel.itemSKUs.count, id: \.self) { i in
                        Text(self.orderModel.itemSKUs[i])
                            .tag(i)
                    }
                }.disabled(orderModel.itemSelection == 0)
                
                Picker(selection: $orderModel.placementTypeSelection, label: Text("Placement Type")) {
                    ForEach(0 ..< orderModel.placementTypes.count, id: \.self) { i in
                        Text(self.orderModel.placementTypes[i])
                            .tag(i)
                    }
                }
                .disabled(orderModel.itemSelection == 0 || orderModel.SKUSelection == 0)
                
                Section {
                    TextField("# of Cases", text: $orderModel.numCases)
                        .keyboardType(.numberPad)
                }.disabled(orderModel.itemSelection == 0 || orderModel.SKUSelection == 0)
                
                Section {
                    DatePicker("Expected Delivery Date:", selection: $orderModel.expectedDeliveryDate)
                }

            }
            .navigationBarTitle("Order", displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: submitButton)
        }
    }
    
    var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
        }
    }
                
    var submitButton: some View {
        Button(action: {
            self.orders.append(self.orderModel)
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Submit")
        }.disabled(!self.orderModel.canSubmit())
    }
    
    func itemSelectionChanged(selection: Int) {
        orderModel.SKUSelection = 0
        orderModel.placementTypeSelection = 0
    }
}

struct OrderView_Previews: PreviewProvider {
    @State static var orders: [OrderViewModel] = []
    static var previews: some View {
        OrderView(brand: mockBrandData[2], orders: $orders)
    }
}
