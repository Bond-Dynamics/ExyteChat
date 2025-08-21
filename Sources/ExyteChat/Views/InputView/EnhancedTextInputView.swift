//
//  EnhancedTextInputView.swift
//  ExyteChat
//
//  Created by Claude on 15.08.2025.
//

import SwiftUI
import UIKit

struct EnhancedTextInputView: View {
    @Environment(\.chatTheme) private var theme
    @EnvironmentObject private var globalFocusState: GlobalFocusState
    
    @Binding var text: String
    @State var inputFieldId: UUID
    var style: InputViewStyle
    var availableInputs: [AvailableInputType]
    var localization: ChatLocalization
    var messageStyler: (String) -> AttributedString
    
    @State private var isFirstResponder = false
    @State private var showMarkdownToolbar = false
    @State private var textViewRef: UITextView?
    
    var body: some View {
        VStack(spacing: 0) {
            if showMarkdownToolbar {
                MarkdownFormattingToolbar { formatType in
                    applyFormatting(formatType)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            HStack {
                MarkdownTextEditor(
                    text: $text,
                    placeholder: style == .message ? localization.inputPlaceholder : localization.signatureText,
                    font: UIFont.systemFont(ofSize: 16),
                    foregroundColor: UIColor(style == .message ? theme.colors.inputText : theme.colors.inputSignatureText),
                    placeholderColor: UIColor(style == .message ? theme.colors.inputPlaceholderText : theme.colors.inputSignaturePlaceholderText),
                    backgroundColor: UIColor.clear,
                    messageStyler: messageStyler,
                    isFirstResponder: $isFirstResponder,
                    onTextViewCreated: { textView in
                        textViewRef = textView
                    }
                )
                .frame(minHeight: 48, maxHeight: 120)
                .onChange(of: globalFocusState.focus) { focus in
                    if case .uuid(let id) = focus, id == inputFieldId {
                        isFirstResponder = true
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showMarkdownToolbar = true
                        }
                    } else {
                        isFirstResponder = false
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showMarkdownToolbar = false
                        }
                    }
                }
                .onTapGesture {
                    globalFocusState.focus = .uuid(inputFieldId)
                }
                
                if !showMarkdownToolbar && isMediaGiphyAvailable() {
                    Spacer(minLength: 0)
                }
            }
            .padding(.horizontal, !isMediaGiphyAvailable() ? 12 : 0)
        }
    }
    
    private func applyFormatting(_ formatType: MarkdownFormatType) {
        guard let textView = textViewRef else { return }
        
        let selectedRange = textView.selectedRange
        let selectedText = textView.text[selectedRange] ?? ""
        
        if selectedText.isEmpty {
            insertFormattingAtCursor(formatType, textView: textView)
        } else {
            wrapSelectedText(formatType, selectedText: selectedText, textView: textView)
        }
    }
    
    private func insertFormattingAtCursor(_ formatType: MarkdownFormatType, textView: UITextView) {
        let syntax = formatType.getMarkdownSyntax()
        let insertText = syntax.prefix + syntax.suffix
        let cursorPosition = textView.selectedRange.location
        
        let newText = (textView.text as NSString).replacingCharacters(
            in: textView.selectedRange,
            with: insertText
        )
        
        text = newText
        
        DispatchQueue.main.async {
            textView.selectedRange = NSRange(
                location: cursorPosition + syntax.prefix.count,
                length: 0
            )
        }
    }
    
    private func wrapSelectedText(_ formatType: MarkdownFormatType, selectedText: String, textView: UITextView) {
        let wrappedText = formatType.wrapText(selectedText)
        let newText = (textView.text as NSString).replacingCharacters(
            in: textView.selectedRange,
            with: wrappedText
        )
        
        text = newText
        
        let syntax = formatType.getMarkdownSyntax()
        let newSelectionStart = textView.selectedRange.location + syntax.prefix.count
        let newSelectionLength = selectedText.count
        
        DispatchQueue.main.async {
            textView.selectedRange = NSRange(
                location: newSelectionStart,
                length: newSelectionLength
            )
        }
    }
    
    
    private func isMediaGiphyAvailable() -> Bool {
        return availableInputs.contains(AvailableInputType.media)
        || availableInputs.contains(AvailableInputType.giphy)
    }
}

extension UITextView {
    subscript(range: NSRange) -> String? {
        guard range.location != NSNotFound,
              range.location + range.length <= text.count else {
            return nil
        }
        
        let start = text.index(text.startIndex, offsetBy: range.location)
        let end = text.index(start, offsetBy: range.length)
        return String(text[start..<end])
    }
}