//
//  LoginView.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 09.05.2024.
//

import SwiftUI
import GoogleSignIn

struct LoginView: View {
    
    @StateObject var signingViewModel = SigningViewModel()
    @EnvironmentObject var model: DrawingViewModel

    @State private var isRecoveryViewPresented = false
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var isValidEmail = true
    @State private var isValidPassword = false
    
    @State private var shouldShowMainView = false
    @State private var isMainViewPresented = false
    
    @FocusState private var isPasswordFieldFocused: Bool
    
    @State private var showAlert = false
    @State private var isLoading = false
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                Color.white
                
                VStack(spacing: 20) {
                    if isLoading {
                        ProgressView("signing-in-string")
                    } else {
                        
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .withTextFieldRectangleModifier()
                            TextField("email-string", text: $email, onEditingChanged: { editing in
                                if !editing {
                                    self.isValidEmail = GlobalMethods.isValidEmail(email)
                                }
                            })
                            .withDefaultTextFieldModifier()
                            .keyboardType(.emailAddress)
                            .submitLabel(.next)
                            .focused($isPasswordFieldFocused)
                            .onSubmit {
                                isPasswordFieldFocused = true
                            }
                        }
                        
                        
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .withTextFieldRectangleModifier()
                            SecureField("password-string", text: $password, onCommit: {
                                self.isValidPassword = GlobalMethods.isValidPassword(password)
                            })
                            .withDefaultTextFieldModifier()
                            .focused($isPasswordFieldFocused)
                            .onTapGesture {
                                isPasswordFieldFocused = false
                            }
                        }
                        
                        Button {
                            self.isRecoveryViewPresented.toggle()
                        } label: {
                            Text("forgot-password-string")
                        }
                        .sheet(isPresented: $isRecoveryViewPresented) {
                            ForgotPasswordView()
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
                            Text("sign-in-string")
                                .bold()
                                .withPrimaryButtonTextViewModifier(foregroundColor: .white, backgroundColor: .blue)
                        })
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("invalid-string"), message: Text("invalid-email-or-password-string"), dismissButton: .default(Text("ok-string")))
                        }
                    
                        
                        OrView()
                        
                        GoogleSigningButton(isSignIn: true) {
                            signingViewModel.signInWithGoogle(completion: { success in
                                
                            })
                        }
                        
                    }
                    
                }
                .padding(15)
                .fullScreenCover(isPresented: $isMainViewPresented) {
                    ChooseOptionView()
                }
                .onAppear {
                    signingViewModel.signInSuccessCallback = {
                        isMainViewPresented = true
                    }
                }
//                .alert(isPresented: $showAlert) {
//                    Alert(title: Text("Alert"), message: Text("Invalid email or password format"), dismissButton: .default(Text("OK")))
//                }
            }
            .ignoresSafeArea()
            .preferredColorScheme(.light)
            .navigationTitle("login-string")
            
            VStack {
                
                Spacer()
                
                Rectangle()
                    .frame(height: 1)
                    .padding(10)
                    .opacity(1)
                    .foregroundStyle(Color.gray20)
                
                
                HStack {
                    Text("dont-have-account-string")
                        .foregroundStyle(Color.gray50)
                    
                    NavigationLink("register-string", destination: RegistrationView(signingViewModel: signingViewModel))
                }
                .padding(.bottom, 30)
                
            }
            .ignoresSafeArea()
            
        }
        
    }
    
}

#Preview {
    LoginView(signingViewModel: SigningViewModel())
    //        .environmentObject(SigningViewModel())
    //
    //    LoginView()
    //        .stateob(SigningViewModel())
    
    //    LoginView(viewModel: SigningViewModel(), isRecoveryViewPresented: , email: <#T##arg#>, password: <#T##arg#>)
}
