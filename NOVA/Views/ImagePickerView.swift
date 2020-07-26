//
//  ImagePickerView.swift
//  NOVA
//
//  Created by pnovacov on 7/12/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI


struct ImagePickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePickerView
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                self.parent.selectedImage = selectedImage
            }
            
            self.parent.isPresented = false
        }
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> ImagePickerView.UIViewControllerType {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {
        
    }
    
}
