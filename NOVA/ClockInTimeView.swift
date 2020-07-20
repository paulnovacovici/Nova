//
//  ClockInTime.swift
//  NOVA
//
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct ClockInTimeView: View {
    @EnvironmentObject var clockedInTimer : TimerManager
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    var body: some View {
        Group {
            if self.clockedInTimer.mode == .running {
                HStack {
                    Text(secondsToHoursMinutesSeconds(seconds: clockedInTimer.secondsElapsed))
                    Image(systemName: "clock")
                }.foregroundColor(Color.green)
            } else {
                EmptyView()
            }
        }
    }
}

struct ClockInTime_Previews: PreviewProvider {
    static var previews: some View {
        ClockInTimeView().environmentObject(TimerManager())
    }
}
