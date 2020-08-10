//
//  AuthView.swift
//  NOVA
//
//  Created by pnovacov on 8/2/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import Combine
import AnyFormatKit

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
    let phoneFormatter = DefaultTextFormatter(textPattern: "(###) ###-####")
    let areaCodeFormatter = DefaultTextFormatter(textPattern: "+###")
    
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var error: String = ""
    @State var showAlert: Bool = false
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var phoneNumber: String = ""
    @State var areaCode: String = ""
    
//    @ObservedObject var keyboardResponder = KeyboardResponder()
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 3)
    
    @EnvironmentObject var session: SessionStore
    
    func verifyFieldsLengths() -> Bool {
        if phoneNumber.count != 10 {
            self.error = "Phone number length isn't correct length"
            self.showAlert = true
            return false
        } else if password != confirmPassword {
            self.error = "Passwords do not match."
            self.showAlert = true
            return false
        }
        
        return email.count > 0 &&
            password.count > 0 &&
            firstName.count > 0 &&
            lastName.count > 0 &&
            areaCode.count > 0 &&
            phoneNumber.count > 0
    }
    
    func signUp() {
        if phoneNumber.count != 10 {
            self.error = "Phone number length isn't correct length"
            self.showAlert = true
        } else if password != confirmPassword {
            self.error = "Passwords do not match."
            self.showAlert = true
        } else if verifyFieldsLengths(){
            // Interporlate phonenumber field
            let number = "\(self.areaCodeFormatter.format(self.areaCode)!) \(self.phoneFormatter.format(self.phoneNumber)!)"
            session.signUp(email: email, password: password, firstName: firstName, lastName: lastName, phoneNumber: number) { (error) in
                self.error = error
                self.showAlert = true
            }
        } else {
            self.error = "Please Fill in all Fields"
            self.showAlert = true
        }
    }
    
    var body: some View {
        let phoneNumberProxy = Binding<String>(
            get: {
                return (self.phoneFormatter.format(self.phoneNumber) ?? "")
            },
            set: {
                self.phoneNumber = self.phoneFormatter.unformat($0) ?? ""
            }
        )
        
        let areaCodeProxy = Binding<String>(
            get: {
                return (self.areaCodeFormatter.format(self.areaCode) ?? "")
            },
            set: {
                self.areaCode = self.areaCodeFormatter.unformat($0) ?? ""
            }
        )
        
        return ScrollView {
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
                        TextFieldContainer("+1", text: areaCodeProxy,
                                           keyboardType: .numberPad, limit: 3,
                                           onEditingChanged: {self.kGuardian.showField = 0})
                            .font(.system(size: 14))
                            .padding(12)
                            .frame(width: 45)
                            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bgl"), lineWidth: 1))
                            .background(GeometryGetter(rect: $kGuardian.rects[0]))
                        
                        TextFieldContainer("Phone Number", text: phoneNumberProxy,
                                           keyboardType: .numberPad, limit: 14,
                                           onEditingChanged: {self.kGuardian.showField = 1})
                            .font(.system(size: 14))
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color("bgl"), lineWidth: 1))
                            .background(GeometryGetter(rect: $kGuardian.rects[1]))
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
            .offset(y: kGuardian.slide)
            .animation(.easeInOut(duration: 0.3))
            .padding(.horizontal, 32)
        }
        .onAppear { self.kGuardian.addObserver() }
        .onDisappear { self.kGuardian.removeObserver() }
    }
}

struct AuthView: View {
    var body: some View {
        NavigationView {
            SignInView()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(SessionStore())
//            .environment(\.colorScheme, .dark)
    }
}
