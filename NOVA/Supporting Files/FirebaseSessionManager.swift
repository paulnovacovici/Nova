//
//  SessionStore.swift
//  NOVA
//
//  Created by pnovacov on 8/2/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Combine
import FirebaseFirestore

class SessionStore: ObservableObject {
    @Published var session: User?
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
//        Auth.auth().currentUser
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
            } else {
                self.session = nil
            }
        })
    }
    
    
    /// Sign Up user and create a firebase account for them.
    /// - Parameters:
    ///   - email: email of user
    ///   - password: password of user
    ///   - handler: handles errors and is called if an error is passed back from firebase
    /// - Returns: void
    func signUp(email: String, password: String, firstName: String, lastName: String, phoneNumber: String, handler: @escaping (String) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let err = err {
                 handler(err.localizedDescription)
                 return
            }
            
            let db = Firestore.firestore()
            
            let userData = [
                "first_name": firstName,
                "last_name": lastName,
                "phone_number": phoneNumber,
                "email": email,
                "uid": result!.user.uid
            ]
            
            db.collection(FirebaseKeys.CollectionPath.users).addDocument(data: userData) { (err) in
                if let error = err {
                    // TODO: Retry adding user meta data because user account was created
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch {
            print("Error signing out")
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
}


struct User {
    var uid: String
    var email: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}


struct FirebaseKeys {
    
    struct CollectionPath {
        static let users = "users"
    }
}
