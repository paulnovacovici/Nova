//
//  Extensions.swift
//  NOVA
//
//  Created by pnovacov on 9/8/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

extension Bool {
    func toPolarAnswer() -> String {
        return self ? "YES" : "NO"
    }
}

// Extend Bindings to have an onChange handler
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
