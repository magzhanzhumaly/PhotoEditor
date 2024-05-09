//
//  DrawingScreen.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 09.05.2024.
//

import SwiftUI
import PencilKit

struct DrawingScreen: View {
    @EnvironmentObject var model: DrawingViewModel
    var body: some View {
        
        ZStack {
            CanvasView(canvas: $model.canvas)
        }
    }
}

struct CanvasView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
    
}

#Preview {
    DrawingScreen()
}
