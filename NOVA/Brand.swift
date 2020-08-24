//
//  Brand.swift
//  NOVA
//
//  Created by pnovacov on 8/23/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Brand: Codable, Identifiable {
    var id: Int?
    var name: String
    var email: String
}
