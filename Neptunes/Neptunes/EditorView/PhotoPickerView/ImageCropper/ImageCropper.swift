//
//  ImageCropper.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-22.
//

import Mantis
import SwiftUI

struct ImageCropper: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var cropShapeType: Mantis.CropShapeType
    var presetFixedRatioType: Mantis.PresetFixedRatioType
    var type: PhotoPickerType
    
    var didCropTrigger: (() -> Void)? = nil
    var didCancelTrigger: (() -> Void)? = nil
    
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: CropViewControllerDelegate {
        var parent: ImageCropper
        
        init(_ parent: ImageCropper) {
            self.parent = parent
        }
        
        func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
            parent.image = cropped
            
            if parent.didCropTrigger != nil {
                parent.didCropTrigger!()
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            if parent.didCancelTrigger != nil {
                parent.didCancelTrigger!()
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        var config = Mantis.Config()
        config.cropViewConfig.cropShapeType = cropShapeType
        config.presetFixedRatioType = presetFixedRatioType
        
//        switch type {
//        case .album:
//            return CropShapeType.square
//        case .artist:
//            return CropShapeType.circle()
//        case .header:
//            return CropShapeType.rect
//        }
        
        let cropViewController = Mantis.cropViewController(image: image ?? UIImage(ciImage: .empty()), config: config)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

