//
//  Brand.swift
//  NOVA
//
//  Created by pnovacov on 8/23/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct BrandDTO: Codable, Identifiable {
    var id: Int?
    var name: String
    var email: String
    var items: [Item]
}

struct Item: Codable {
    var name: String
    var SKUs: [String]
}

