//
//  CheckIn.swift
//  NOVA
//
//  Created by pnovacov on 7/20/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct StoreCheckIn: Codable, Identifiable {
    // TODO: Add ID so we can do last doc comparison's in History
    @DocumentID var id: String?
    var store: String
    var manager: String
    var arrivalTime: Date
    var needs: String
    var shelfStocked: Bool
    var images: [String]
    var userId: String
    var show: Bool = false
    var isShimmer: Bool = false
    @ServerTimestamp var createdTime: Timestamp?
    
    init() {
        self.store = ""
        self.manager = ""
        self.arrivalTime = Date()
        self.needs = ""
        self.shelfStocked = false
        self.images = []
        self.show = false
        self.userId = ""
        self.isShimmer = true
    }
    
    init(store: String, manager: String, arrivalTime: Date, needs: String, shelfStocked: Bool, images: [String], userId: String) {
        self.store = store
        self.manager = manager
        self.arrivalTime = arrivalTime
        self.needs = needs
        self.shelfStocked = shelfStocked
        self.images = images
        self.userId = userId
        self.show = false
        self.isShimmer = false
    }
    
    enum CodingKeys: String, CodingKey {
        case shelfStocked = "shelf_stocked"
        case arrivalTime = "arrival_time"
        case createdTime = "created_time"
        
        case store
        case userId
        case manager
        case needs
        case images
        case id
    }
}
