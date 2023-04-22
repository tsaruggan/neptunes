//
//  ImageCropper.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-22.
//

import Mantis
import SwiftUI

enum ImageCropperType {
    case normal
    case noRotationDial
    case noAttachedToolbar
}

struct ImageCropper: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var cropShapeType: Mantis.CropShapeType
    var presetFixedRatioType: Mantis.PresetFixedRatioType
    var type: ImageCropperType
    
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
        switch type {
        case .normal:
            return makeNormalImageCropper(context: context)
        case .noRotationDial:
            return makeImageCropperHidingRotationDial(context: context)
        case .noAttachedToolbar:
            return makeImageCropperWithoutAttachedToolbar(context: context)
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

extension ImageCropper {
    func makeNormalImageCropper(context: Context) -> UIViewController {
        var config = Mantis.Config()
        config.cropViewConfig.cropShapeType = cropShapeType
        config.presetFixedRatioType = presetFixedRatioType
        let cropViewController = Mantis.cropViewController(image: image ?? UIImage(ciImage: .empty()), config: config)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
    
    func makeImageCropperHidingRotationDial(context: Context) -> UIViewController {
        var config = Mantis.Config()
        config.cropViewConfig.showRotationDial = false
        let cropViewController = Mantis.cropViewController(image: image ?? UIImage(ciImage: .empty()), config: config)
        cropViewController.delegate = context.coordinator
        
        return cropViewController
    }
    
    func makeImageCropperWithoutAttachedToolbar(context: Context) -> UIViewController {
        var config = Mantis.Config()
        config.showAttachedCropToolbar = false
        let cropViewController: ImageCropperViewController = Mantis.cropViewController(image: image ?? UIImage(ciImage: .empty()), config: config)
        cropViewController.delegate = context.coordinator
        
        return UINavigationController(rootViewController: cropViewController)
    }
}
