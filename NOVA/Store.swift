//
//  Store.swift
//  NOVA
//
//  Created by pnovacov on 8/23/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Store: Codable, Identifiable {
    var id: Int?
    var name: String
    var address: String?
    var state: String?
    var city: String?
    var zipCode: String?
    var fullAddress: String? {
        if let address = address, let city = city, let state = state {
            return"\(address), \(city), \(state)"
        } else {
            return nil
        }
    }
}
