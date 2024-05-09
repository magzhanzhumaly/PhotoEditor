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
    
    //    @State private var isShowingImagePicker = false
    @State private var rotationAngle: Double = 0.0
    @State private var scale: CGFloat = 1.0
    @State private var filterIntensity = 0.5
    @State private var canvasView = PKCanvasView()

    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                //                if processedImage == nil {
                //                    PhotosPicker(selection: $pickerItem, matching: .images) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if processedImage != nil {
                        //                            self.processedImage = processedImage
                        
                        //                        processedImage
                        //                            .resizable()
                        //                            .scaledToFill()
                        
                        ZStack(alignment: .topTrailing) {
                            
                            VStack {
                                Spacer()
                                
                                
                                DrawingScreen()
                                    .environmentObject(model)
                                processedImage!
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(Angle(degrees: rotationAngle))
                                    .scaleEffect(scale)
                                    .overlay(PencilKitCanvas(canvasView: $canvasView))

                                Spacer()
                            }
                            
                            Button {
                                processedImage = nil
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(.red)
                            }
                            .padding(.trailing, 15)
                            
                        }
                    } else {
                        VStack {
                            if #available(iOS 17.0, *) {
                                ContentUnavailableView("no-picture-string", systemImage: "photo.badge.plus", description: Text("tap-to-select-a-photo-string"))
                            } else {
                                Label("select-a-picture-string", systemImage: "photo")
                            }
                            
                            Spacer()
                            
                        }
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem) { newItem in
                    loadImage()
                }
                
                HStack {
                    Text("rotation-string")
                        .frame(width: 80)
                    
                    Slider(value: $rotationAngle, in: 0...360)
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                
                
                HStack {
                    Text("intensity-string")
                        .frame(width: 80)
                    
                    Slider(value: $filterIntensity, in: 0.0...1.0) {
                        Text("scale-string")
                    }
                    .onChange(of: filterIntensity, applyFilter)
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                
                HStack {
                    Text("zoom-string")
                        .frame(width: 80)
                    
                    Slider(value: $scale, in: 0.5...2.0) {
                        Text("scale-string")
                    }
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                
                HStack {
//                    Button("change-filter-string", action: applyFilter)
                    Menu {
                        Button("sepia-tone-string") {
                            currentFilter = CIFilter.sepiaTone()
                            applyFilter()
                        }
                        Button("remove-effect-string") {
                            filterIntensity = 0
                            applyFilter()
//                            currentFilter = CIFilter.sepiaTone()
                            
//                            applyFilter()
                        }
                        // Add more filter options here as needed
                    } label: {
                        Label("change-filter-string", systemImage: "wand.and.rays")
                    }

                }
                //                .onChange(of: selectedItem, loadImage)
                
                if processedImage == nil {
                    HStack {
                        Text("is-signed-in-string")
                            .foregroundStyle(.black)
                        
                        Button {
                            signingViewModel.signOut()
                        } label: {
                            Text("sign-out-string")
                                .foregroundStyle(.blue)
                        }
                    }
                    .padding(.top, 50)
                }
            }
            
        }
        .navigationTitle("photo-editor-string")
    }
    
    private func changeFilter() {
        
    }
    
    private func loadImage() {
        //        guard let item = pickerItem else { return }
        
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
    
//    applyFilterOnce() {
//        process
//    }
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
        
        // Apply the filter
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

//    private func applyFilter() {
//        currentFilter.intensity = Float(filterIntensity)
//        
//        guard let outputImage = currentFilter.outputImage else { return }
//        
//        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
//        
//        let uiImage = UIImage(cgImage: cgImage)
//        let image = Image(uiImage: uiImage)
//        processedImage = image
//    }
}


#Preview {
    NavigationView {
        MainView(model: DrawingViewModel(), signingViewModel: SigningViewModel())
    }
}

