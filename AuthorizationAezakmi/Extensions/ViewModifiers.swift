//
//  ViewModifiers.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 09.05.2024.
//

import SwiftUI

struct TextFieldViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .frame(height: 50)
            .foregroundStyle(.black)
            .padding(.leading, 10)
    }
}

struct RectangleViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke()
            .foregroundColor(Color.gray10)
            .frame(height: 50)
    }
}

