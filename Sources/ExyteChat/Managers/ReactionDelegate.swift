//
//  ReactionDelegate.swift
//  Chat
//

/// A delegate for responding to MessageProtocol Reactions and optionally configuring the Reaction Menu
///
/// ```swift
/// func didReact(to message: MessageProtocol, reaction: DraftReaction)
///
/// // Optional configuration methods
/// func shouldShowOverview(for message: MessageProtocol) -> Bool
/// func canReact(to message: MessageProtocol) -> Bool
/// func reactions(for message: MessageProtocol) -> [ReactionType]?
/// func allowEmojiSearch(for message: MessageProtocol) -> Bool
/// ```
public protocol ReactionDelegate {
    
    /// Called when the sender reacts to a message
    /// - Parameters:
    ///   - message: The `MessageProtocol` they reacted to
    ///   - reaction: The `DraftReaction` that should be sent / applied to the `MessageProtocol`
    func didReact(to message: MessageProtocol, reaction: DraftReaction) -> Void
    
    /// Determines whether or not the Sender can react to a given `MessageProtocol`
    /// - Parameter message: The `MessageProtocol` the Sender is interacting with
    /// - Returns: A Bool indicating whether or not the Sender should be able to react to the given `MessageProtocol`
    ///
    /// - Note: Optional, defaults to `true`
    /// - Note: Called when Chat is preparing to show the MessageProtocol Menu
    func canReact(to message: MessageProtocol) -> Bool
    
    /// Allows for the configuration of the Reactions available to the Sender for a given `MessageProtocol`
    /// - Parameter message: The `MessageProtocol` the Sender is interacting with
    /// - Returns: A list of `ReactionTypes` available for the Sender to use
    ///
    /// - Note: Optional, defaults to a standard set of emojis
    /// - Note: Called when Chat is preparing to show the MessageProtocol Menu
    func reactions(for message: MessageProtocol) -> [ReactionType]?
    
    /// Whether or not the Sender should be able to search for an emoji using the Keyboard for a given `MessageProtocol`
    /// - Parameter message: The `MessageProtocol` the Sender is interacting with
    /// - Returns: Whether or not the Sender can search for a custom emoji.
    ///
    /// - Note: Optional, defaults to `true`
    /// - Note: Called when Chat is preparing to show the MessageProtocol Menu
    func allowEmojiSearch(for message: MessageProtocol) -> Bool
    
    /// Whether or not the MessageProtocol Menu should include a reaction overview at the top of the screen
    /// - Parameter message: The `MessageProtocol` the Sender is interacting with
    /// - Returns: Whether the overview is shown or not
    ///
    /// - Note: Optional, defaults to `true` when the message has one or more reactions.
    /// - Note: Called when Chat is preparing to show the MessageProtocol Menu
    func shouldShowOverview(for message: MessageProtocol) -> Bool
}

public extension ReactionDelegate {
    func canReact(to message: MessageProtocol) -> Bool { true }
    func reactions(for message: MessageProtocol) -> [ReactionType]? { nil }
    func allowEmojiSearch(for message: MessageProtocol) -> Bool { true }
    func shouldShowOverview(for message:MessageProtocol) -> Bool { !message.reactions.isEmpty }
}

/// We use this implementation of ReactionDelegate for when the user wants to use the callback modifier instead of providing us with a dedicated delegate
struct DefaultReactionConfiguration: ReactionDelegate {
    // Non optional didReact handler
    var didReact: (MessageProtocol, DraftReaction) -> Void
    
    // Optional handlers for further configuration
    var canReact: ((MessageProtocol) -> Bool)? = nil
    var reactions: ((MessageProtocol) -> [ReactionType]?)? = nil
    var allowEmojiSearch: ((MessageProtocol) -> Bool)? = nil
    var shouldShowOverview: ((MessageProtocol) -> Bool)? = nil
    
    init(
        didReact: @escaping (MessageProtocol, DraftReaction) -> Void,
        canReact: ((MessageProtocol) -> Bool)? = nil,
        reactions: ((MessageProtocol) -> [ReactionType]?)? = nil,
        allowEmojiSearch: ((MessageProtocol) -> Bool)? = nil,
        shouldShowOverview: ((MessageProtocol) -> Bool)? = nil
    ) {
        self.didReact = didReact
        self.canReact = canReact
        self.reactions = reactions
        self.allowEmojiSearch = allowEmojiSearch
        self.shouldShowOverview = shouldShowOverview
    }
    
    func didReact(to message: MessageProtocol, reaction: DraftReaction) {
        didReact(message, reaction)
    }
    
    func shouldShowOverview(for message: MessageProtocol) -> Bool {
        if let shouldShowOverview { return shouldShowOverview(message) }
        else { return !message.reactions.isEmpty }
    }
    
    func canReact(to message: MessageProtocol) -> Bool {
        if let canReact { return canReact(message) }
        else { return true }
    }
    
    func reactions(for message: MessageProtocol) -> [ReactionType]? {
        if let reactions { return reactions(message) }
        else { return nil }
    }
    
    func allowEmojiSearch(for message: MessageProtocol) -> Bool {
        if let allowEmojiSearch { return allowEmojiSearch(message) }
        else { return true }
    }
}
