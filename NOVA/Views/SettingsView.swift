//
//  SettingsView.swift
//  NOVA
//
//  Created by pnovacov on 8/2/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var session: SessionStore
    
    func signOut() {
        session.signOut()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading) {
                            Text("Email:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(session.session?.email ?? "foobar@gmail.com")
                                .font(.callout)
                        }
                    }
                }
                .padding(.top)
                .padding(.bottom)
                
                Section {
                    Button(action: signOut) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }.navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(SessionStore())
    }
}
