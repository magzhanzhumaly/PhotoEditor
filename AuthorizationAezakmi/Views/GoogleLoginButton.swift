//
//  GoogleLoginButton.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 09.05.2024.
//

import SwiftUI

struct GoogleSigningButton: View {
    
    let isSignIn: Bool
    let onTapAction: () -> Void
    
    var body: some View {
        Button(action: onTapAction) {
            HStack {
                Image("google_logo")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(isSignIn ? "sign-in-with-google-string" : "sign-up-with-google-string")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
            }
            .foregroundColor(.clear)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 10,
                             style: .continuous)
            .fill(Color.gray10)
        )
    }
}

#Preview {
    GoogleSigningButton(isSignIn: true, onTapAction: { print("button tapped" )})
}
