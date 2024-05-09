//
//  DrawingViewModel.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 09.05.2024.
//

import Foundation
import PencilKit
class DrawingViewModel: ObservableObject {
    @Published var showImagePicker = false
    @Published var imageData: Data = Data(count: 0)
    
    @Published var canvas = PKCanvasView()
    
    func cancelImageEditing() {
        imageData = Data(count: 0)
    }
}
