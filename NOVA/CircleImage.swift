//
//  CircleImage.swift
//  NOVA
//
//  Created by pnovacov on 7/6/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("Cliffs")
            .frame(width: 200.0, height: 200.0)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
        .shadow(radius: 10)
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
