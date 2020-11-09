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
    var items: [ItemDTO]
    var questions: [QuestionDTO]?
}

struct ItemDTO: Codable {
    var name: String
    var SKUs: [String]
}

enum Type: String, Codable {
    case bool, string
}

struct QuestionDTO: Codable {
    var question: String
    var type: Type
    var answers: [String]?
}

