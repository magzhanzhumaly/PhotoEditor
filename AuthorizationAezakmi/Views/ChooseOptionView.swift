//
//  ChooseOptionView.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 10.05.2024.
//

import SwiftUI

struct ChooseOptionView: View {
    
    @StateObject var signingViewModel = SigningViewModel()
    @State private var isLoggedOut = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            HStack {
                NavigationLink("apply-effects-string", destination: ApplyEffects(model: DrawingViewModel(), signingViewModel: SigningViewModel()))
            }
            
            HStack {
                NavigationLink("draw-string", destination: MainView(model: DrawingViewModel(), signingViewModel: SigningViewModel()))
            }
            
            Spacer()
            
            HStack {
                Text("is-signed-in-string")
                    .foregroundStyle(.black)
                
                Button {
                    signingViewModel.signOut()
                    isLoggedOut = true
                } label: {
                    Text("sign-out-string")
                        .foregroundStyle(.blue)
                }
            }
        }
        .fullScreenCover(isPresented: $isLoggedOut) {
            NavigationView {
                LoginView()
            }
        }
    }
}

#Preview {
    ChooseOptionView()
}
