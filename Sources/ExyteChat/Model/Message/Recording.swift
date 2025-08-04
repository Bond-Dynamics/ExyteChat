//
//  Recording.swift
//  Chat
//
//  Created by Michael Shaw on 8/4/25.
//

import Foundation

public struct Recording: Codable, Hashable, Sendable {
    public var duration: Double
    public var waveformSamples: [CGFloat]
    public var url: URL?

    public init(duration: Double = 0.0, waveformSamples: [CGFloat] = [], url: URL? = nil) {
        self.duration = duration
        self.waveformSamples = waveformSamples
        self.url = url
    }
}
