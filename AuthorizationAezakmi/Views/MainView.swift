//
//  MainView.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 09.05.2024.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import SwiftUI
import PencilKit

struct MainView: View {
    
    @StateObject var model = DrawingViewModel()
    @StateObject var signingViewModel: SigningViewModel
    
    @State private var processedImage: Image? // = Image(uiImage: UIImage(named: "AppIcon")!)
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var rotationAngle: Double = 0.0
    @State private var scale: CGFloat = 1.0
    @State private var filterIntensity = 0.5
    @State private var canvasView = PKCanvasView()
    
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    
    var body: some View {
        ZStack {
            NavigationView {
                
                VStack {
                    
                    // Image is added
                    
                    if let _ = UIImage(data: model.imageData) {
                        
                        DrawingScreen()
                            .environmentObject(model)
                        
                            .toolbar(content: {
                                
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button(action: model.cancelImageEditing, label: {
                                        Image(systemName: "xmark")
                                    })
                                }
                            })
                        
                    // Image isn't added
                    } else {
                        
                        Spacer()
                        Button(action: {
                            model.showImagePicker.toggle()
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.black)
                                .frame(width: 70, height: 70)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.07),
                                        radius: 5, x: 5, y: 5)
                                .shadow(color: Color.black.opacity(0.07),
                                        radius: 5, x: -5, y: -5)
                        })
                        
                        
                        Spacer()
                    }
                }
            }
            
                    
            if model.addNewBox {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                TextField("type-here-string", text: $model.textBoxes[model.currentIndex].text)
                    .font(.system(size: 35, weight: model.textBoxes[model.currentIndex].isBold ? .bold : .regular))
                
                    .colorScheme(.dark)
                    .foregroundColor(model.textBoxes[model.currentIndex].textColor)
                    .padding()
                
                
                HStack {
                    Button(action: {
                        model.textBoxes[model.currentIndex].isAdded = true
                        model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                        model.canvas.becomeFirstResponder()
                        withAnimation {
                            model.addNewBox = false
                        }
                    }, label: {
                        Text("add-string")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                    
                    Spacer()
                    
                    Button(action: model.cancelTextView, label: {
                        Text("cancel-string")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                }
                .overlay(
                    HStack(spacing: 15) {
                        ColorPicker("", selection: $model.textBoxes[model.currentIndex].textColor).labelsHidden()
                        //.labelsHidden()
                        
                        Button(action: {
                            model.textBoxes[model.currentIndex].isBold.toggle()
                        }, label: {
                            Text(model.textBoxes[model.currentIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .sheet(isPresented: $model.showImagePicker, content: {
            ImagePicker(showPicker: $model.showImagePicker, imageData: $model.imageData)
        })
        .alert(isPresented: $model.showAlert, content: {
            Alert(title: Text("message-string"), message: Text(model.message), dismissButton: .destructive(Text("ok-string")))
        })
    }

    private func changeFilter() {
        
    }
    
    private func loadImage() {
        Task {
            do {
                processedImage = try await selectedItem?.loadTransferable(type: Image.self)
            } catch {
                print("\("error-loading-image-string".localizedCapitalized)  \(error)")
            }
            
            
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else {
                return
            }
            
            guard let inputImage = UIImage(data: imageData) else {
                return
            }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyFilter()
        }
    }
    
    private func applyFilterOnce() {
        currentFilter.setValue(filterIntensity, forKey: "inputIntensity")
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        let image = Image(uiImage: uiImage)
        processedImage = image
    }
    
    
    private func applyFilter(filter: CIFilter) {
        // Set intensity if the filter supports it
        if filter.attributes.keys.contains(kCIInputIntensityKey) {
            filter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        guard let outputImage = filter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        let image = Image(uiImage: uiImage)
        processedImage = image
    }
    
    private func applyFilter() {
        currentFilter.setValue(filterIntensity, forKey: "inputIntensity")
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        let image = Image(uiImage: uiImage)
        processedImage = image
    }
}


#Preview {
    NavigationView {
        MainView(model: DrawingViewModel(), signingViewModel: SigningViewModel())
    }
}


