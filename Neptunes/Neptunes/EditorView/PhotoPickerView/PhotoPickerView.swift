//
//  PhotoPickerView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-22.
//

import SwiftUI
import PhotosUI
import Mantis
import Shiny

enum PhotoPickerType {
    case album
    case artist
    case header
}

struct PhotoPickerView: View {
    @Binding var image: UIImage?
    var placeholder: UIImage?
    var type: PhotoPickerType
    var onChange: () -> Void
    
    @State var presentingCropper: Bool = false
    @State var selectedPhotosPickerItem: PhotosPickerItem? = nil
    @State var selectedImage: UIImage? = nil
    
    var body: some View {
        PhotosPicker(selection: $selectedPhotosPickerItem, matching: .images) {
            VStack {
                HStack{
                    Spacer()
                    picture
                    Spacer()
                }
                HStack(spacing: 36) {
                    Spacer()
                    
                    editButton
                    if image != nil {
                        removeButton
                    }
                    
                    Spacer()
                }
            }
            .animation(.easeInOut(duration: 0.5), value: image)
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
        getFormattedPicture()
    }
    
    func getFormattedPicture() -> some View {
        let cornerRadius = 8.0
        return AnyView(
            Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                    
                } else if let placeholder = placeholder {
                    Image(uiImage: placeholder)
                        .resizable()
                } else {
                    ZStack {
                        Rectangle().fill(.ultraThickMaterial)
                        Image(systemName: "photo").foregroundColor(.gray)
                    }
                }
            }
            .transition(.push(from: .bottom))
            .cornerRadius(cornerRadius)
            .aspectRatio(getPrefixedRatio(), contentMode: .fit)
            .frame(width: type == .header ? nil : 100, height: type == .header ? nil : 100)
            .frame(maxWidth: type == .header ? .infinity : 100, maxHeight: 100)
            .clipShape(getClipShape())
        )
    }
    
    var editButton: some View {
        Image(systemName: "pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 12, height: 12) // Adjust size of the badge
            .foregroundColor(.blue)
            .padding(8)
            .background(Color.blue.opacity(0.1)) // Light background for contrast
            .clipShape(Capsule())
    }
    
    
    var removeButton: some View {
        Button(action: {
            clear()
        }) {
            Image(systemName: "trash")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12) // Adjust size of the badge
                .foregroundColor(.red)
                .padding(8)
                .background(Color.red.opacity(0.1)) // Light background for contrast
                .clipShape(Circle())
        }
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
