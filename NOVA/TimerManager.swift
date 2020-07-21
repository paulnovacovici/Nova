//
//  Timer.swift
//  NOVA
//
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import Foundation
import SwiftUI

class TimerManager: ObservableObject {
    @Published var secondsElapsed = 0
    @Published var mode: StopWatchMode = .stopped
    var timer = Timer()
    
    enum StopWatchMode {
        case running
        case stopped
        case paused
    }
    
    func stop() {
        mode = .stopped
        timer.invalidate()
        secondsElapsed = 0
    }
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.secondsElapsed += 1
        })
    }
    
    func toggle() {
        if mode == .running {
            stop()
        } else {
            start()
        }
    }
}
