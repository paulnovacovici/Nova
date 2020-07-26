//
//  TPImagePicker.swift
//  NOVA
//
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import Combine
import ImagePicker

struct TPImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TPImagePicker>) -> ImagePickerController {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = context.coordinator
        imagePickerController.imageLimit = 10
        
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerController, context: Context) {
        
    }
}

extension TPImagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, ImagePickerDelegate {
        let parent: TPImagePicker
        
        init(parent: TPImagePicker) {
            self.parent = parent
        }
        
        func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
            
        }
        
        func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
            self.parent.images = images
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
        func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}



