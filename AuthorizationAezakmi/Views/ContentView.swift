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
    @EnvironmentObject var model: DrawingViewModel
    @State var a = 5
    
    var body: some View {
        
        NavigationView {
            if signingViewModel.signedIn {
                MainView(model: model, signingViewModel: signingViewModel)
            } else {
                LoginView(viewModel: signingViewModel)
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
//            .preferredColorScheme(.light)
        //            .environment(\.locale,
        //                          Locale.init(identifier: "en"))
        //        ContentView()
        //            .environment(\.locale,
        //                          Locale.init(identifier: "ru"))
    }
}

