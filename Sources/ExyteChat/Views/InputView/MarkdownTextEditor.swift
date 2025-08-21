//
//  MarkdownTextEditor.swift
//  ExyteChat
//
//  Created by Claude on 15.08.2025.
//

import SwiftUI
import UIKit

struct MarkdownTextEditor: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let font: UIFont
    let foregroundColor: UIColor
    let placeholderColor: UIColor
    let backgroundColor: UIColor
    let messageStyler: (String) -> AttributedString
    
    @Binding var isFirstResponder: Bool
    let onTextViewCreated: ((UITextView) -> Void)?
    
    init(
        text: Binding<String>,
        placeholder: String,
        font: UIFont,
        foregroundColor: UIColor,
        placeholderColor: UIColor,
        backgroundColor: UIColor,
        messageStyler: @escaping (String) -> AttributedString,
        isFirstResponder: Binding<Bool>,
        onTextViewCreated: ((UITextView) -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.font = font
        self.foregroundColor = foregroundColor
        self.placeholderColor = placeholderColor
        self.backgroundColor = backgroundColor
        self.messageStyler = messageStyler
        self._isFirstResponder = isFirstResponder
        self.onTextViewCreated = onTextViewCreated
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.backgroundColor = backgroundColor
        textView.font = font
        textView.textColor = foregroundColor
        textView.returnKeyType = .default
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        
        updatePlaceholder(textView)
        onTextViewCreated?(textView)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let coordinator = context.coordinator
        
        if uiView.text != text {
            coordinator.isUpdatingFromBinding = true
            
            if text.isEmpty {
                updatePlaceholder(uiView)
            } else {
                let attributedText = messageStyler(text).toAttrString(font: font)
                uiView.attributedText = attributedText
            }
            
            coordinator.isUpdatingFromBinding = false
        }
        
        if isFirstResponder && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFirstResponder && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }
    
    private func updatePlaceholder(_ textView: UITextView) {
        textView.attributedText = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: font,
                .foregroundColor: placeholderColor
            ]
        )
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MarkdownTextEditor
        var isUpdatingFromBinding = false
        
        init(_ parent: MarkdownTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            guard !isUpdatingFromBinding else { return }
            
            let newText = textView.text ?? ""
            
            if newText != parent.text {
                parent.text = newText
                
                if !newText.isEmpty {
                    let attributedText = parent.messageStyler(newText).toAttrString(font: parent.font)
                    
                    let selectedRange = textView.selectedRange
                    isUpdatingFromBinding = true
                    textView.attributedText = attributedText
                    textView.selectedRange = selectedRange
                    isUpdatingFromBinding = false
                }
            }
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == parent.placeholderColor {
                textView.text = ""
                textView.textColor = parent.foregroundColor
            }
            parent.isFirstResponder = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                parent.updatePlaceholder(textView)
            }
            parent.isFirstResponder = false
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if textView.textColor == parent.placeholderColor && !text.isEmpty {
                textView.text = ""
                textView.textColor = parent.foregroundColor
                return true
            }
            return true
        }
    }
}