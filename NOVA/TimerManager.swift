//
//  Timer.swift
//  NOVA
//
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import Foundation
import SwiftUI

enum StopWatchMode {
    case running
    case stopped
    case paused
}

class TimerManager: ObservableObject {
    @Published var secondsElapsed = 0
    @Published var mode: StopWatchMode = .stopped
    var timer = Timer()
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.secondsElapsed += 1
        })
    }
    
    func stop() {
        mode = .stopped
        timer.invalidate()
        secondsElapsed = 0
    }
}
