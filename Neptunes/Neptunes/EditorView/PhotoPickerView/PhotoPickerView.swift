//
//  PhotoPickerView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-22.
//

import SwiftUI
import PhotosUI

enum PhotoPickerType {
    case album
    case artist
    case header
}

struct PhotoPickerView: View {
    @Binding var image: UIImage?
    var placeholder: String
    var type: PhotoPickerType
    var onChange: (UIImage?) -> Void
    
    @State var presentingCropper: Bool = false
    @State var selectedPhotosPickerItem: PhotosPickerItem? = nil
    @State var selectedImage: UIImage? = nil
    
    var body: some View {
        PhotosPicker(selection: $selectedPhotosPickerItem, matching: .images) {
            HStack{
                picture
                Spacer()
                removeButton
            }
        }
        .onChange(of: selectedPhotosPickerItem) { newItem in
            onPhotosPickerItemChange(item: newItem)
        }
        .fullScreenCover(isPresented: $presentingCropper, content: {
            ImageCropper(image: $selectedImage,
                         cropShapeType: .square,
                         presetFixedRatioType: .alwaysUsingOnePresetFixedRatio(),
                         type: .normal,
                         didCropTrigger: didCrop,
                         didCancelTrigger: didCancel)
            .ignoresSafeArea()
        })
    }
    
    var picture: some View {
        Image(uiImage: image ?? UIImage(named: placeholder)!)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .clipShape(getClipShape())
    }
    
    var removeButton: some View {
        Button("remove") {
            clear()
        }
        .padding()
        .buttonStyle(.bordered)
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
        onChange(selectedImage)
    }
    
    func didCancel() {
        selectedPhotosPickerItem = nil
        selectedImage = nil
    }
    
    func clear() {
        selectedPhotosPickerItem = nil
        selectedImage = nil
        image = nil
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
}

