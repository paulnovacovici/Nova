//
//  History.swift
//  NOVA
//  Lot's of help from https://www.youtube.com/watch?v=3ktaVsniPnU
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var locationManager : LocationManager
    @State private var data = [StoreCheckIn]()
    
    
    var body: some View {
        NavigationView {
            VStack {
                if !self.data.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(self.data, id: \.self) { i in
                                ZStack {
                                    if i.store == "" {
                                        // Shimmer Row
                                        HStack {
                                            Rectangle()
                                                .fill(Color.black.opacity(0.09))
                                                .frame(width: 200, height: 15)
                                            Spacer()
                                            Rectangle()
                                                .fill(Color.black.opacity(0.09))
                                                .frame(width: 100, height: 15)
                                        }
                                        
                                        // Shimmer Animation...
                                        HStack {
                                            Rectangle()
                                                .fill(Color.white.opacity(0.6))
                                                .frame(width: 200, height: 15)
                                            Spacer()
                                            Rectangle()
                                                .fill(Color.white.opacity(0.6))
                                                .frame(width: 100, height: 15)
                                        }
                                        // Masking View
                                        .mask(
                                            Rectangle()
                                                .fill(Color.white.opacity(0.6))
                                                .rotationEffect(.init(degrees: 70))
                                            // Moving View
                                                .offset(x: i.show ? 1000 : -350)
                                        )
                                    }

                                }.padding()
                            }
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
            }
            .navigationBarTitle(Text("History"))
            .navigationBarItems(leading: TimerView().environmentObject(locationManager))
        }.onAppear(perform: loadTempData)
    }
    
    func loadTempData() {
        for i in 0...19 {
            let temp = StoreCheckIn(store: "", manager: "", arrivalTime: Date(), needs: "", shelfStocked: true, images: [], userId: "")
            
            self.data.append(temp)
            
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                self.data[i].show.toggle()
            }
        }
    }
    func loadData() {
//        let dataRef = FirestoreReferenceManager.root.collection(FirebaseKeys.CollectionPath.checkIns)
    }
}

struct HistoryRow: View {
    var storeName: String
    var arrivalTime: Date
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()
    
    var body: some View {
        HStack {
            Text(storeName)
            Spacer()
            Text("\(arrivalTime, formatter: Self.taskDateFormat)")
        }
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environmentObject(LocationManager())
    }
}
