//
//  RegistrationView.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 09.05.2024.
//

import SwiftUI

struct RegistrationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var model: DrawingViewModel

    @StateObject var signingViewModel: SigningViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var isValidEmail = false
    @State private var isValidPassword = false
    
    @State private var isMainViewPresented = false
    
    @State private var showAlert = false
    
    @State private var isLoading = false


    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                if isLoading {
                    ProgressView("signing-up-string")
                } else {
                    
                    Color.white
                    
                    
                    VStack(spacing: 20) {
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .withTextFieldRectangleModifier()
                            
                            TextField("email-string", text: $email, onEditingChanged: { editing in
                                if !editing {
                                    self.isValidEmail = GlobalMethods.isValidEmail(email)
                                }
                            })
                            .withDefaultTextFieldModifier()
                            .keyboardType(.emailAddress)
                        }
                        
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .withTextFieldRectangleModifier()
                            
                            SecureField("password-string", text: $password, onCommit: {
                                self.isValidPassword = GlobalMethods.isValidPassword(password)
                            })
                            .withDefaultTextFieldModifier()
                        }
                        
                        
                        Button(action: {
                            isValidEmail = GlobalMethods.isValidEmail(email)
                            isValidPassword = GlobalMethods.isValidPassword(password)
                            
                            if !isValidEmail || !isValidPassword {
                                showAlert = true
                            } else {
                                signingViewModel.signIn(email: email, password: password)
                                { success in
                                    isLoading = false
                                    if !success {
                                        showAlert = true
                                    }
                                }
                                isLoading = true
                            }
                        }, label: {
                            Text("sign-up-string")
                                .bold()
                                .withPrimaryButtonTextViewModifier(foregroundColor: .white, backgroundColor: .blue)
                        })
                        
                        OrView()
                        
                        GoogleSigningButton(isSignIn: false, onTapAction: {
                            print("sign-up-with-google-string")
                        })
                        
                    }
                    .padding(15)
                    
                    .fullScreenCover(isPresented: $isMainViewPresented) {
                        MainView(model: model, signingViewModel: signingViewModel)
                    }
                    .onAppear {
                        signingViewModel.signInSuccessCallback = {
                            isMainViewPresented = true
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("alert-string"), message: Text("invalid-email-or-password-string"), dismissButton: .default(Text("ok-string")))
                    }
                }
            }
            .ignoresSafeArea()
            .preferredColorScheme(.light)
            .navigationTitle("register-string")
            
            
            
            VStack {
                
                Spacer()
                
                Rectangle()
                    .frame(height: 1)
                    .padding(10)
                    .opacity(1)
                    .foregroundStyle(Color.gray20)
                
                
                HStack {
                    Text("already-have-an-account-string")
                        .foregroundStyle(Color.gray50)
                    
                    Button("login-string") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding(.bottom, 30)

            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MainView(model: DrawingViewModel(), signingViewModel: SigningViewModel())
}
