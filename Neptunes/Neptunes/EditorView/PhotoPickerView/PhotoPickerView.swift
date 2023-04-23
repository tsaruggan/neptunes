//
//  PhotoPickerView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-22.
//

import SwiftUI
import PhotosUI
import Mantis

enum PhotoPickerType {
    case album
    case artist
    case header
}

struct PhotoPickerView: View {
    @Binding var image: UIImage?
    var placeholder: String
    var type: PhotoPickerType
    var onChange: () -> Void
    
    @State var presentingCropper: Bool = false
    @State var selectedPhotosPickerItem: PhotosPickerItem? = nil
    @State var selectedImage: UIImage? = nil
    
    var body: some View {
        PhotosPicker(selection: $selectedPhotosPickerItem, matching: .images) {
            HStack{
                picture
                Spacer()
                
                if image != nil {
                    removeButton
                }
            }
        }
        .onChange(of: selectedPhotosPickerItem) { newItem in
            onPhotosPickerItemChange(item: newItem)
        }
        .fullScreenCover(isPresented: $presentingCropper, content: {
            ImageCropper(image: $selectedImage,
                         cropShapeType: getCropShape(),
                         presetFixedRatioType: .alwaysUsingOnePresetFixedRatio(ratio: getPrefixedRatio()),
                         type: type,
                         didCropTrigger: didCrop,
                         didCancelTrigger: didCancel)
            .ignoresSafeArea()
        })
    }
    
    var picture: some View {
        Image(uiImage: image ?? UIImage(named: placeholder)!)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: type == .header ? 100 / 3 : 100)
            .clipShape(getClipShape())
    }
    
    var removeButton: some View {
        Button("remove", role: .destructive, action: {
            clear()
        })
        .padding()
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
    }
    
    func onPhotosPickerItemChange(item: PhotosPickerItem?) {
        Task {
            if let imageData = try? await item?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.selectedImage = uiImage
                    self.presentingCropper = true
                }
            }
        }
    }
    
    func didCrop() -> Void {
        image = selectedImage
        onChange()
    }
    
    func didCancel() {
        selectedPhotosPickerItem = nil
        selectedImage = nil
    }
    
    func clear() {
        selectedPhotosPickerItem = nil
        selectedImage = nil
        image = nil
        
        onChange()
    }
    
    func getClipShape() -> AnyShape {
        switch type {
        case .album:
            return AnyShape(Rectangle())
        case .artist:
            return AnyShape(Circle())
        case .header:
            return AnyShape(Rectangle())
        }
    }
    
    func getCropShape() -> CropShapeType {
        switch type {
        case .album:
            return CropShapeType.square
        case .artist:
            return CropShapeType.circle()
        case .header:
            return CropShapeType.rect
        }
    }
    
    func getPrefixedRatio() -> Double {
        switch type {
        case .album:
            return 1.0 / 1.0
        case .artist:
            return 1.0 / 1.0
        case .header:
            return 3.0 / 1.0
        }
    }
}

