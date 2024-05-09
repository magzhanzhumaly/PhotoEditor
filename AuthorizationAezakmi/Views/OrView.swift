//
//  OrView.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 09.05.2024.
//

import SwiftUI

struct OrView: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .padding(10)
                .foregroundStyle(Color.gray20)
            
            Text("or-string")
            
            Rectangle()
                .frame(height: 1)
                .padding(10)
                .foregroundStyle(Color.gray20)
        }
    }
}

#Preview {
    OrView()
}
