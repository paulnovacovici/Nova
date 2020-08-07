//
//  AuthView.swift
//  NOVA
//
//  Created by pnovacov on 8/2/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import Combine

struct SignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @State var showAlert: Bool = false
    @EnvironmentObject var session: SessionStore
    
    func signIn() {
        session.signIn(email: email, password: password){ (result, error) in
            if let error = error {
                self.error = error.localizedDescription
                self.showAlert = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Welcome Back!")
                .font(.system(size: 32, weight: .heavy))
            
            Text("Sign in to continue")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
            
            VStack(spacing: 10) {
                TextField("Email Address", text: $email)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bgl"), lineWidth: 1))
                
                SecureField("Password", text: $password)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bgl"), lineWidth: 1))
            }
            .padding(.vertical, 64)
            
            Button(action: signIn) {
                Text("Sign in")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .background(Color(.black))
                    .cornerRadius(5)
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(error))
            }
            
            Spacer()
            
            NavigationLink(destination: SignUpView()) {
                HStack {
                    Text("Don't have an account?")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.primary )
                    
                    Text("Create an account")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
        }
        .padding(.horizontal, 32)
    }
}

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var error: String = ""
    @State var showAlert: Bool = false
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var phoneNumber: String = ""
    
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @ObservedObject var areaCode = TextBindingManager(limit: 1)
    
    @EnvironmentObject var session: SessionStore
    
    func verifyFields() -> Bool {
        return email.count > 0 &&
            password.count > 0 &&
            firstName.count > 0 &&
            lastName.count > 0 &&
            areaCode.text.count > 0 &&
            phoneNumber.count > 0
    }
    
    func signUp() {
        if phoneNumber.count != 10 {
            self.error = "Phone number length isn't correct length"
            self.showAlert = true
        } else if password != confirmPassword {
            self.error = "Passwords do not match."
            self.showAlert = true
        } else if verifyFields(){
            session.signUp(email: email, password: password) { (result, error) in
                if let error = error {
                    self.error = error.localizedDescription
                    self.showAlert = true
                } else {
                    self.email = ""
                    self.password = ""
                }
            }
        } else {
            self.error = "Please Fill in all Fields"
            self.showAlert = true
        }
    }
    
    var body: some View {
        VStack {
            Text("Create an Account")
                .font(.system(size: 32, weight: .heavy))
            
            Text("Sign up to get started")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
            
            VStack(spacing: 18) {
                HStack {
                    TextField("First Name", text: $firstName)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bgl"), lineWidth: 1))
                    
                    TextField("Last Name", text: $lastName)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bgl"), lineWidth: 1))
                }
                
                TextField("Email address", text: $email)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bgl"), lineWidth: 1))
                
                SecureField("Password", text: $password)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bgl"), lineWidth: 1))
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bgl"), lineWidth: 1))
                
                HStack {
                    TextField("+1", text: $areaCode.text)
                        .keyboardType(.numberPad)
                        .font(.system(size: 14))
                        .padding(12)
                        .frame(width: 45)
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bgl"), lineWidth: 1))
                    
                    TextFieldContainer("Phone Number", text: $phoneNumber, keyboardType: .numberPad, limit: 10)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bgl"), lineWidth: 1))
                }
                
            }.padding(.vertical, 64)
            
            Button(action: signUp) {
                Text("Create Account")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .background(Color(.black))
                    .cornerRadius(5)
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(error))
            }
            
            Spacer()
        }
        .offset(y: -keyboardResponder.currentHeight * 0.9)
        .padding(.horizontal, 32)
    }
}

struct AuthView: View {
    var body: some View {
        NavigationView {
//            SignInView()
            SignUpView()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(SessionStore())
//            .environment(\.colorScheme, .dark)
    }
}
