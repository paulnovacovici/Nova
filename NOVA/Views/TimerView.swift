//
//  ClockInTime.swift
//  NOVA
//
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var locationManager : LocationManager
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    var body: some View {
        Group {
            if self.locationManager.mode == .running {
                HStack {
                    Text(secondsToHoursMinutesSeconds(seconds: locationManager.seconds))
                    Image(systemName: "clock")
                }.foregroundColor(Color.green)
            } else {
                EmptyView()
            }
        }
    }
}

struct ClockInTime_Previews: PreviewProvider {
    static var timeManager: TimerManager {
        get{
            let t = TimerManager()
            t.mode = .running
            t.start()
            return t
        }
    }
    
    static var previews: some View {
        TimerView().environmentObject(timeManager)
    }
}
