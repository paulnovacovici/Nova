//
//  History.swift
//  NOVA
//
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var clockedInTimer : TimerManager
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Woodmans")
                    Spacer()
                    Text("\(Date(), formatter: Self.taskDateFormat)")
                }
            }
            .navigationBarTitle(Text("History"))
            .navigationBarItems(leading: ClockInTimeView().environmentObject(clockedInTimer))
        }
        
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
