# 🌀 DistortedTextColumn & 🎥 LoopingVideoView

This repository includes two SwiftUI components that combine creative animation and multimedia rendering using **Canvas**, **Core Text**, and **AVKit**.

---

## 🌀 DistortedTextColumn

**`DistortedTextColumn`** is a SwiftUI view that renders multiline text in a fixed-width column using **Core Text** and **Canvas**, then applies a smooth **sine-wave distortion** to create a living, rippling text effect.

It combines the precision of Core Text layout with the power of GPU-accelerated SwiftUI drawing.

### ✨ Features
- Automatic text wrapping within a fixed column width  
- Animated sine-wave distortion driven by time  
- Fully configurable parameters for amplitude, frequency, speed, font size, and color  
- Uses Core Text + SwiftUI `Canvas` for efficient rendering  
- Looks great in posters, generative art, and motion UI

### ⚙️ Parameters

| Parameter | Type | Description |
|------------|------|-------------|
| **`text`** | `String` | The text to display. Can be multiline — automatically wraps to fit the column width. |
| **`amplitude`** | `CGFloat` | Vertical displacement of the sine wave (in points). Larger values produce a stronger wobble. |
| **`frequency`** | `CGFloat` | Controls how many waves appear across the text horizontally. Higher = tighter waves. |
| **`speed`** | `CGFloat` | Speed of wave motion. Increasing makes the wave animate faster. |
| **`columnWidth`** | `CGFloat` | Fixed width (in points) of the column; text wraps automatically at this width. |
| **`fontSize`** | `CGFloat` | Size of the rendered text. |
| **`fillColor`** | `Color` | Color used to fill the text shapes. |

### 🧩 Example Usage

```swift
DistortedTextColumn(
    text: """
    This is a sample multiline text that wraps inside a fixed column width.
    It ripples and moves using a sine-wave animation.
    """ ,
    amplitude: 40,
    frequency: 0.03,
    speed: 2,
    columnWidth: 300,
    fontSize: 60,
    fillColor: .black
)
.frame(maxWidth: .infinity, maxHeight: .infinity)
.background(Color.white)
```

### 🪄 How It Works
`DistortedTextColumn`:
1. Uses **Core Text** to generate properly wrapped glyph paths.  
2. Applies a **time-based sine offset** to every path element via a `distortPath` function.  
3. Draws the result in a SwiftUI **Canvas** for smooth GPU rendering.  
4. Animates continuously using a `TimelineView(.animation)`.

### 💡 Tips
- For subtle motion, use low amplitude (10–30) and low frequency (0.01–0.03).  
- For liquid or surreal effects, increase amplitude and lower frequency.  
- Combine with gradient fills or masks for more experimental visuals.  

---

## 🎥 LoopingVideoView

`LoopingVideoView` is a lightweight SwiftUI wrapper around **AVPlayer** that lets you play looping video content inside your app — ideal for backgrounds, previews, or ambient motion elements in your UI.

It automatically:
- Loads and plays a local or remote video file.
- Loops the video seamlessly by restarting playback when it finishes.
- Supports corner radius, aspect fill, and layering options.

### ⚙️ Parameters

| Parameter | Type | Description |
|------------|------|-------------|
| **`player`** | `AVPlayer` | The AVPlayer instance to play. Use a shared or preloaded player to avoid restarts. |
| **`cornerRadius`** | `CGFloat` | Optional radius for rounding the video’s corners. |
| **`videoGravity`** | `AVLayerVideoGravity` | Controls how the video scales within its layer (`.resizeAspectFill`, `.resizeAspect`, etc.). Default is `.resizeAspectFill`. |

### 🧩 Example Usage

```swift
import AVKit

struct ExampleView: View {
    private let player = AVPlayer(url: Bundle.main.url(forResource: "sample", withExtension: "mp4")!)

    var body: some View {
        LoopingVideoView(player: player, cornerRadius: 12)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 5)
    }
}
```

### 🧱 Full Implementation — `LoopingVideoView`

```swift
import SwiftUI
import AVKit

/// A SwiftUI view that plays looping video content using AVPlayer.
/// Ideal for backgrounds, previews, and ambient animations.
struct LoopingVideoView: UIViewRepresentable {
    /// The AVPlayer instance that plays the video.
    /// Keep this persistent (e.g., in a parent view) to prevent restarts.
    let player: AVPlayer
    
    /// Optional corner radius for rounding the video edges.
    var cornerRadius: CGFloat = 0
    
    /// Video scaling mode: `.resizeAspectFill`, `.resizeAspect`, or `.resize`.
    var videoGravity: AVLayerVideoGravity = .resizeAspectFill
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // Create the AVPlayerLayer and attach it to the view’s layer.
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = videoGravity
        playerLayer.cornerRadius = cornerRadius
        playerLayer.masksToBounds = true
        view.layer.addSublayer(playerLayer)
        
        // Start playback
        player.play()
        player.actionAtItemEnd = .none
        
        // Restart video when it finishes (loop)
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Ensure layer resizes with SwiftUI layout changes
        if let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer {
            playerLayer.frame = uiView.bounds
        }
    }
}
```

### 💡 Notes
- This implementation uses **UIKit integration** (`UIViewRepresentable`) for maximum control.  
- You can easily extend it to:
  - Add **play/pause controls** or gestures.  
  - Handle **remote video URLs** (streaming).  
  - Apply **blend modes**, overlays, or filters using SwiftUI layers.  
- Works perfectly with multiple `LoopingVideoView` instances on screen if each uses its own `AVPlayer`.

---

## 🧠 Credits
Built with ❤️ using SwiftUI, Core Text, and AVKit.
