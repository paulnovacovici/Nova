//
//  History.swift
//  NOVA
//
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var locationManager : LocationManager
    @State private var data = [StoreCheckIn]()
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.data) { storeCheckIn in
                    HStack {
                        Text(storeCheckIn.storeName)
                        Spacer()
                        Text("\(storeCheckIn.arrivalTime, formatter: Self.taskDateFormat)")
                    }
                }
            }
            .navigationBarTitle(Text("History"))
            .navigationBarItems(leading: TimerView().environmentObject(locationManager))
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        // TODO: Do network request to get history of user data
//        https://www.hackingwithswift.com/books/ios-swiftui/sending-and-receiving-codable-data-with-urlsession-and-swiftui
        self.data = storeCheckInData.sorted(by: { $0.arrivalTime.compare($1.arrivalTime) == .orderedDescending
        })
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environmentObject(TimerManager())
    }
}
