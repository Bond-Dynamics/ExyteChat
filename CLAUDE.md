# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ExyteChat is a SwiftUI chat UI framework with fully customizable message cells and built-in media picker. This is a Swift Package Manager library designed for iOS 17+.

## Development Commands

### Code Formatting
- Use swift-format with the configuration in `.swift-format`
- Format a file: `swift-format format -i --configuration .swift-format path/to/file.swift`
- Configuration uses 4 spaces for indentation

### Building and Testing
- Build the library: `swift build`
- Run tests: `swift test`
- For example projects: Open `ChatExample.xcodeproj` or `ChatFirestoreExample.xcodeproj` in Xcode

### Markdown Features
- Enable markdown input: `.setAvailableInputs([.text, .media, .audio, .markdown])`
- Real-time markdown formatting with visual toolbar
- Supports bold, italic, strikethrough, lists, quotes, and code blocks

### Message Editing
- Enable editing with state bindings and callback:
```swift
@State private var isEditing = false
@State private var messageToEdit: (any MessageProtocol)?
@State private var editingText = ""

ChatView(
    messages: messages,
    didSendMessage: { /* handle new messages */ },
    onMessageEdit: { editedMessage, newText in
        // Handle message edit
    },
    isEditingMessage: $isEditing,
    messageBeingEdited: $messageToEdit,
    editingText: $editingText
)
```

### Example Projects
Two example projects demonstrate the library:
- `ChatExample/` - Simple bot with random messages, no backend
- `ChatFirestoreExample/` - Full Firestore integration with media storage

## Code Architecture

### Core Components

**ChatView** (`Sources/ExyteChat/Views/ChatView.swift`)
- Main entry point for the chat UI
- Generic over MessageContent, InputViewContent, MenuAction, and MessageData
- Supports two chat types: `.conversation` (bottom-up) and `.comments` (top-down)
- Two reply modes: `.quote` and `.answer`

**Message Model** (`Sources/ExyteChat/Model/Message/`)
- `Message.swift` - Core message structure with status, user, attachments
- `MessageProtocol.swift` - Protocol defining message interface
- `DraftMessage.swift` - Messages being composed
- `ReplyMessage.swift` - Reply-specific functionality

**User Model** (`Sources/ExyteChat/Model/User.swift`)
- Represents chat participants
- Has `isCurrentUser` property for distinguishing message ownership

**Theme System** (`Sources/ExyteChat/Theme/`)
- `ChatTheme.swift` - Customizable colors and images
- Uses SwiftUI environment for theme injection
- Auto-customizes MediaPicker based on chat theme

**Views Structure**
- `MessageView/` - Message display components including reactions, menus, avatars
- `InputView/` - Text input and attachment handling, including markdown support
  - `TextInputView.swift` - Basic text input
  - `EnhancedTextInputView.swift` - Advanced text input with markdown toolbar
  - `MarkdownTextEditor.swift` - UITextView wrapper with real-time markdown formatting
  - `MarkdownFormattingToolbar.swift` - Visual formatting controls
- `Attachments/` - Media display and fullscreen viewers
- `Recording/` - Audio recording functionality
- `Giphy/` - Sticker/GIF integration

### Key Features

**Customization**
- Custom message builders via `MessageBuilderClosure`
- Custom input view builders via `InputViewBuilderClosure` 
- Custom message menu actions via `MessageMenuAction` protocol
- Swipe actions on messages

**Media Support**
- Photo/video attachments via ExyteMediaPicker
- Audio recording and playback
- Link previews with caching
- GIF/sticker support via Giphy SDK

**Markdown Support**
- Real-time markdown formatting in text input
- Visual formatting toolbar with common formatting options
- Support for bold, italic, strikethrough, lists, quotes, code blocks
- Automatic conversion to AttributedString for display

**Message Editing**
- Edit existing messages with pre-populated text input
- Visual editing indicator with cancel option
- Save/Cancel buttons replace Send button during editing
- Focus management for smooth editing experience
- Custom onMessageEdit callback for handling edits

**Interaction Features**
- Message reactions
- Reply functionality (quote or answer modes)
- Message editing and deletion
- Long press context menus
- Pagination for message loading

### Dependencies
- ExyteMediaPicker (media selection)
- ActivityIndicatorView (loading states)
- GiphyUISDK (sticker/GIF functionality)

## Code Style Guidelines

From CONTRIBUTING.md:
- 4 spaces for indentation
- No spaces on empty lines
- Comments start with lowercase: `// start with small letter`
- Variable declarations: `var users: [User]`
- Use swift-format before commits to ensure consistent style

## Architecture Patterns

**Protocol-Oriented Design**
- `MessageProtocol` allows custom message types
- `MessageMenuAction` for extensible menu actions

**Environment-Based Configuration**
- Theme and configuration passed via SwiftUI environment
- Supports both Swift 5.x and 6.0+ environment patterns

**Generic UI Components**
- ChatView is generic over content types for maximum flexibility
- Closure-based builders for custom UI components

**State Management**
- ViewModel pattern for chat state
- Separate managers for focus, keyboard, pagination states