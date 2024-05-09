//
//  ApplyEffects.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 10.05.2024.
//

import SwiftUI
import PhotosUI

struct ApplyEffects: View {
    
    @StateObject var model = DrawingViewModel()
    @StateObject var signingViewModel: SigningViewModel
    
    @State private var processedImage: Image? // = Image(uiImage: UIImage(named: "AppIcon")!)
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var rotationAngle: Double = 0.0
    @State private var scale: CGFloat = 1.0
    @State private var filterIntensity = 0.5
    
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if processedImage != nil {
                        
                        ZStack(alignment: .topTrailing) {
                            
                            VStack {
                                Spacer()
                                
                                processedImage!
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(Angle(degrees: rotationAngle))
                                    .scaleEffect(scale)
                                
                                Spacer()
                            }
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
                    Menu {
                        Button("sepia-tone-string") {
                            currentFilter = CIFilter.sepiaTone()
                            applyFilter()
                        }
                        Button("remove-effect-string") {
                            filterIntensity = 0
                            applyFilter()
                        }
                    } label: {
                        Label("change-filter-string", systemImage: "wand.and.rays")
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        processedImage = nil
                    } label: {
                        Text("remove-image-string")
                            .foregroundStyle(.red)
                    }
                    
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
        .toolbar(content: {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    let activityViewController = UIActivityViewController(activityItems: [processedImage?.asUIImage().pngData() as Any], applicationActivities: nil)
                    UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                    
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if let image = processedImage?.asUIImage().pngData() {
                        UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
                    }
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                })
            }
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
    ApplyEffects(model: DrawingViewModel(), signingViewModel: SigningViewModel())
}
