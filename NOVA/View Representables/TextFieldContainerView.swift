//
//  TextBindingManager.swift
//  NOVA
//
//  Created by pnovacov on 8/5/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import UIKit


struct TextFieldContainer: UIViewRepresentable {
    private var placeholder : String
    private var text : Binding<String>
    private var keyboardType: UIKeyboardType
    private var characaterLimit: Int
    private var onEditingChanged: (() -> Void)?

    init(_ placeholder:String, text:Binding<String>, keyboardType: UIKeyboardType = .default, limit: Int = 5, onEditingChanged: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.text = text
        self.keyboardType = keyboardType
        self.characaterLimit = limit
        self.onEditingChanged = onEditingChanged
    }

    func makeCoordinator() -> TextFieldContainer.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<TextFieldContainer>) -> UITextField {

        let innertTextField = UITextField(frame: .zero)
        innertTextField.placeholder = placeholder
        innertTextField.text = text.wrappedValue
        innertTextField.delegate = context.coordinator
        innertTextField.keyboardType = keyboardType

        context.coordinator.setup(innertTextField)

        return innertTextField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldContainer>) {
        uiView.text = self.text.wrappedValue
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldContainer

        init(_ textFieldContainer: TextFieldContainer) {
            self.parent = textFieldContainer
        }

        func setup(_ textField:UITextField) {
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""

            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }

            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under the characterLimit
            return updatedText.count <= self.parent.characaterLimit
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.parent.onEditingChanged?()
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            self.parent.text.wrappedValue = textField.text ?? ""
        }
    }
}
