//
//  ClockInView.swift
//  NOVA
//
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct ClockInView: View {
    @EnvironmentObject var clockedInTimer : TimerManager
    
    var body: some View {
        NavigationView {
            VStack {
                if (clockedInTimer.mode == .stopped) {
                    Button(action: {
                        self.clockedInTimer.start()
                    }) {
                        Text("Clock In")
                    }
                } else {
                    Button(action: {
                        self.clockedInTimer.stop()
                    }) {
                        Text("Clock out")
                    }
                }
                
            }
            .navigationBarItems(leading: ClockInTimeView().environmentObject(clockedInTimer))
        }
        
    }
}

struct ClockInView_Previews: PreviewProvider {
    static var previews: some View {
        ClockInView().environmentObject(TimerManager())
    }
}
