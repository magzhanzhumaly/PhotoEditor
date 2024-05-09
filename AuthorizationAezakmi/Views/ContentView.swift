//
//  ContentView.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 06.05.2024.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var signingViewModel: SigningViewModel
    @StateObject var model = DrawingViewModel()
    @State var a = 5
    
    var body: some View {
        
        NavigationView {
            if signingViewModel.signedIn {
                ChooseOptionView()
            } else {
                LoginView(signingViewModel: signingViewModel)
            }
        }
        .onAppear {
            signingViewModel.signedIn = signingViewModel.isSignedIn
        }
        .preferredColorScheme(.light)
    }
}


#Preview {
    Group {
        let viewModel = SigningViewModel()
        ContentView()
            .environmentObject(viewModel) 
    }
}

