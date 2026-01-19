//
//  ContentView.swift
//  testing
//
//  Created by student on 16/10/2025.
//

import SwiftUI
import AVFoundation
import UIKit

// MARK: - UIKit-backed player layer for SwiftUI (no controls)
struct PlayerLayerView: UIViewRepresentable {
    let player: AVPlayer
    var cornerRadius: CGFloat = 0

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.player = player
        view.backgroundColor = .clear
        view.cornerRadius = cornerRadius
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {
        uiView.player = player
        uiView.cornerRadius = cornerRadius
    }
}

// A UIView that hosts an AVPlayerLayer
final class PlayerView: UIView {
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    private var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

    var player: AVPlayer? {
        get { playerLayer.player }
        set {
            playerLayer.player = newValue
            playerLayer.videoGravity = .resizeAspectFill // Fill to match the rounded tile look
        }
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure masking is maintained during layout changes
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
    }
}

// MARK: - SwiftUI wrapper that owns the player and loops
struct LoopingVideoView: View {
    let player: AVPlayer
    @State private var isPlaying = false
    var cornerRadius: CGFloat = 0

    init(url: URL, cornerRadius: CGFloat = 0) {
        self.player = AVPlayer(url: url)
        self.cornerRadius = cornerRadius
        // Optional: improve startup behavior for short clips
        self.player.actionAtItemEnd = .none
        // Reduce stutter on loop
        self.player.currentItem?.preferredForwardBufferDuration = 1
        // Keep audio silent by default (uncomment if needed)
        // self.player.isMuted = true
    }

    var body: some View {
        PlayerLayerView(player: player, cornerRadius: cornerRadius)
            .onAppear {
                addLooping()
                if !isPlaying {
                    player.play()
                    isPlaying = true
                }
            }
            .onDisappear {
                player.pause()
                isPlaying = false
            }
    }

    private func addLooping() {
        // Remove previous observers to avoid duplicates
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak player] _ in
            guard let player = player else { return }
            player.seek(to: .zero)
            player.play()
        }
    }
}

//private var demoVideoURL: URL? {Bundle.main.url(forResource: "sample", withExtension: "mp4")}
// LoopingVideoView(url: url, cornerRadius: 20)

