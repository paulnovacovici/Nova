//
//  LoadingView.swift
//  NOVA
//
//  Created by pnovacov on 8/16/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        GeometryReader { _ in
            VStack {
                Loader()
            }
        }.background(Color.black.opacity(0.15).edgesIgnoringSafeArea(.all))
    }
}

struct Loader : View {
    
    @State var show = false
    
    var body : some View{
        
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .frame(width: 35, height: 35)
            .rotationEffect(.init(degrees: self.show ? 360 : 0))
            .animation(Animation.default.repeatForever(autoreverses: false).speed(0.5))
            .padding(40)
            .cornerRadius(15)
            .onAppear {
                
                self.show.toggle()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
