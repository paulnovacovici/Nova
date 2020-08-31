//
//  Order.swift
//  NOVA
//
//  Created by pnovacov on 8/30/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct OrderDTO: Codable, Identifiable {
    var id: Int?
    var brandName: String
    var item: String
    var SKU: String
    var cases: Int
    var placementType: String
    var expectedDeliveryDate: Date
}
