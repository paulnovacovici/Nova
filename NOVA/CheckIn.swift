//
//  CheckIn.swift
//  NOVA
//
//  Created by pnovacov on 7/20/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct StoreCheckIn: Hashable, Codable, Identifiable {
    var id: Int
    var storeName: String
    var managerIn: Bool
    var spokeTo: String
    var arrivalTime: Date
    var needs: String
}
