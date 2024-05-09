//
//  Extensions.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 06.05.2024.
//

import SwiftUI

extension Color {
    static let gray10 = Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0))
    static let gray20 = Color(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0))
    static let gray30 = Color(UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0))
    static let gray40 = Color(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0))
    static let gray50 = Color(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0))
    static let gray60 = Color(UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0))
    static let gray70 = Color(UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0))
    static let gray80 = Color(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0))
    static let gray90 = Color(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0))
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func withDefaultTextFieldModifier() -> some View {
        modifier(TextFieldViewModifier())
    }
    
    func withTextFieldRectangleModifier() -> some View {
        modifier(RectangleViewModifier())
    }
    
    func withPrimaryButtonTextViewModifier(foregroundColor: Color, backgroundColor: Color) -> some View {
        modifier(PrimaryButtonTextViewModifier(foregroundColor: foregroundColor, backgroundColor: backgroundColor))
    }

    
}

struct PrimaryButtonTextViewModifier: ViewModifier {
    
    let foregroundColor: Color
    let backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 10,
                                 style: .continuous)
                .fill(.blue)
            )
            .foregroundStyle(foregroundColor)
    }
    
}




