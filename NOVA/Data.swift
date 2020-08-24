//
//  Data.swift
//  NOVA
//
//  Created by pnovacov on 7/20/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

let storeCheckInData: [StoreCheckIn] = load("mockCheckInData.json")
let mockStoreData: [Store] = [Store(name: "None")] + load("mockStoreData.json")
let mockBrandData: [Brand] = [Brand(name: "None", email: "")] + load("mockBrandData.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
