//
//  MarkdownFormattingToolbar.swift
//  ExyteChat
//
//  Created by Claude on 15.08.2025.
//

import SwiftUI

enum MarkdownFormatType: CaseIterable {
    case bold
    case italic
    case strikethrough
    case bulletList
    case numberedList
    case quote
    case code
    case codeBlock
    
    var symbol: String {
        switch self {
        case .bold: return "bold"
        case .italic: return "italic"
        case .strikethrough: return "strikethrough"
        case .bulletList: return "list.bullet"
        case .numberedList: return "list.number"
        case .quote: return "quote.bubble"
        case .code: return "curlybraces"
        case .codeBlock: return "curlybraces.square"
        }
    }
    
    var accessibilityLabel: String {
        switch self {
        case .bold: return "Bold"
        case .italic: return "Italic"
        case .strikethrough: return "Strikethrough"
        case .bulletList: return "Bullet List"
        case .numberedList: return "Numbered List"
        case .quote: return "Quote"
        case .code: return "Inline Code"
        case .codeBlock: return "Code Block"
        }
    }
    
    func wrapText(_ text: String) -> String {
        switch self {
        case .bold:
            return "**\(text)**"
        case .italic:
            return "*\(text)*"
        case .strikethrough:
            return "~~\(text)~~"
        case .code:
            return "`\(text)`"
        case .codeBlock:
            return "```\n\(text)\n```"
        case .quote:
            let lines = text.components(separatedBy: .newlines)
            return lines.map { "> \($0)" }.joined(separator: "\n")
        case .bulletList:
            let lines = text.components(separatedBy: .newlines)
            return lines.map { "- \($0)" }.joined(separator: "\n")
        case .numberedList:
            let lines = text.components(separatedBy: .newlines)
            return lines.enumerated().map { index, line in
                "\(index + 1). \(line)"
            }.joined(separator: "\n")
        }
    }
    
    func getMarkdownSyntax() -> (prefix: String, suffix: String) {
        switch self {
        case .bold:
            return ("**", "**")
        case .italic:
            return ("*", "*")
        case .strikethrough:
            return ("~~", "~~")
        case .code:
            return ("`", "`")
        case .codeBlock:
            return ("```\n", "\n```")
        case .quote:
            return ("> ", "")
        case .bulletList:
            return ("- ", "")
        case .numberedList:
            return ("1. ", "")
        }
    }
}

struct MarkdownFormattingToolbar: View {
    @Environment(\.chatTheme) private var theme
    
    let onFormatAction: (MarkdownFormatType) -> Void
    @State private var isExpanded = false
    
    private let mainFormats: [MarkdownFormatType] = [.bold, .italic, .bulletList, .numberedList]
    private let expandedFormats: [MarkdownFormatType] = MarkdownFormatType.allCases
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ForEach(isExpanded ? expandedFormats : mainFormats, id: \.self) { format in
                    formatButton(for: format)
                }
                
                Spacer()
                
                expandButton
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(theme.colors.inputBG)
            
            Divider()
                .background(theme.colors.mainText.opacity(0.1))
        }
    }
    
    @ViewBuilder
    private func formatButton(for format: MarkdownFormatType) -> some View {
        Button {
            onFormatAction(format)
        } label: {
            Image(systemName: format.symbol)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(theme.colors.mainText)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(theme.colors.mainText.opacity(0.1))
                )
        }
        .accessibilityLabel(format.accessibilityLabel)
    }
    
    private var expandButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        } label: {
            Image(systemName: isExpanded ? "chevron.up" : "ellipsis")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(theme.colors.mainText.opacity(0.7))
                .frame(width: 28, height: 28)
        }
        .accessibilityLabel(isExpanded ? "Collapse toolbar" : "Expand toolbar")
    }
}
