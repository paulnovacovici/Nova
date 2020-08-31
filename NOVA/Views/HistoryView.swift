//
//  History.swift
//  NOVA
//  Lot's of help from https://www.youtube.com/watch?v=3ktaVsniPnU
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import Firebase

struct HistoryView: View {
    @EnvironmentObject var locationManager : LocationManager
    @State private var data = [StoreCheckInDTO]()
    
    // For tracking how long the user pulls up on last element in list
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    
    // Tracking last document on page for server side pagination
    @State var lastDoc: QueryDocumentSnapshot!
    
    
    var body: some View {
        NavigationView {
            VStack {
                if !self.data.isEmpty {
                    // TODO: See if same logic is doable with List or Divider
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(self.data) { checkIn in
                                ZStack {
                                    if checkIn.isShimmer {
                                        HistoryRowShimmer(show: checkIn.show)
                                    }
                                    else {
                                        // Show Data
                                        ZStack {
                                            // Check to see if last element is in view
                                            if self.data.last?.id == checkIn.id {
                                                GeometryReader { g in
                                                    HistoryRow(storeName: checkIn.store, arrivalTime: checkIn.arrivalTime, address: checkIn.address)
                                                        .onAppear {
                                                            self.timer = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
                                                        }
                                                    .onReceive(self.timer) { (_) in
                                                        if g.frame(in: .global).maxY < UIScreen.main.bounds.height - 80 {
                                                            // TODO: Call update data
                                                            print("Updating Data...")
                                                            self.timer.upstream.connect().cancel()
                                                        }
                                                    }
                                                }.frame(height: 65 )
                                            } else {
                                                HistoryRow(storeName: checkIn.store, arrivalTime: checkIn.arrivalTime, address: checkIn.address)
                                            }
                                        }
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
        }.onAppear {
            if self.data.isEmpty {
                self.loadShimmerData()
            }
            
            // Connect to firebase
            self.loadData()
        }
    }
    
    func loadShimmerData() {
        for i in 0...19 {
            let temp = StoreCheckInDTO()
            
            self.data.append(temp)
            
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                self.data[i].show.toggle()
            }
        }
    }
    func loadData() {
        let dbRef = FirestoreReferenceManager.root.collection(FirebaseKeys.CollectionPath.checkIns)
        
        dbRef.whereField("userId", isEqualTo: Auth.auth().currentUser!.uid).order(by: StoreCheckInDTO.CodingKeys.arrivalTime.rawValue, descending: true).limit(to: 20).getDocuments { (snap, err) in
            if let err = err {
                // TODO: show error
                print(err.localizedDescription)
                return
            }
            
            // Remove shimmer data
            self.data.removeAll()
            
            for doc in snap!.documents {
                let result = Result {
                    try doc.data(as: StoreCheckInDTO.self)
                }
                
                switch result {
                    case .success(let checkIn):
                        if let checkIn = checkIn {
                            self.data.append(checkIn)
                        } else {
                            // TODO: raise alert
                            print("No documents found")
                    }
                    case .failure(let err):
                        print(err.localizedDescription)
                }
            }
            
            // Save last document for next page request
            self.lastDoc = snap!.documents.last
        }
    }
}

struct HistoryRow: View {
    var storeName: String
    var arrivalTime: Date
    var address: String
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(storeName)
                Text(address)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                    .lineLimit(1)
            }
            Spacer()
            Text("\(arrivalTime, formatter: Self.taskDateFormat)")
        }
    }
}

struct HistoryRowShimmer: View {
    var show: Bool
    
    var body: some View {
        ZStack {
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
                    .offset(x: show ? 1000 : -350)
            )
        }
    }
}


struct History_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environmentObject(LocationManager())
    }
}
