import SwiftUI
import CoreText

struct DistortedTextColumn: View {
    let text: String
    let amplitude: CGFloat
    let frequency: CGFloat
    let speed: CGFloat
    let columnWidth: CGFloat
    let fontSize: CGFloat
    let fillColor: Color
    
    @State private var time: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    
                    // MARK: - Text Preparation
                    
                    let font = CTFontCreateWithName("Helvetica" as CFString, fontSize, nil)
                    let attributes: [NSAttributedString.Key: Any] = [.font: font]
                    let attributedString = NSAttributedString(string: text, attributes: attributes)
                    let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
                    
                    let pathRect = CGRect(x: 0, y: 0, width: columnWidth, height: size.height)
                    let framePath = CGPath(rect: pathRect, transform: nil)
                    let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedString.length), framePath, nil)
                    
                    let lines = CTFrameGetLines(frame) as! [CTLine]
                    var lineOrigins = Array<CGPoint>(repeating: .zero, count: lines.count)
                    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &lineOrigins)
                    
                    // MARK: - Layout and Path Construction
                    
                    let currentTime = timeline.date.timeIntervalSinceReferenceDate
                    let textPath = CGMutablePath()
                    
                    for (index, line) in lines.enumerated() {
                        let lineOrigin = lineOrigins[index]
                        let runs = CTLineGetGlyphRuns(line) as! [CTRun]
                        
                        for run in runs {
                            let runAttributes = CTRunGetAttributes(run) as NSDictionary
                            let runFont = runAttributes[kCTFontAttributeName as String] as! CTFont
                            
                            let glyphCount = CTRunGetGlyphCount(run)
                            for i in 0..<glyphCount {
                                var glyph = CGGlyph()
                                var position = CGPoint()
                                CTRunGetGlyphs(run, CFRangeMake(i, 1), &glyph)
                                CTRunGetPositions(run, CFRangeMake(i, 1), &position)
                                
                                let waveY = position.y + lineOrigin.y + amplitude * sin(frequency * position.x + speed * CGFloat(currentTime))
                                
                                if let letterPath = CTFontCreatePathForGlyph(runFont, glyph, nil) {
                                    let transform = CGAffineTransform(translationX: position.x + lineOrigin.x, y: waveY)
                                    textPath.addPath(letterPath, transform: transform)
                                }
                            }
                        }
                    }
                    
                    // MARK: - Distortion
                    
                    let distortedPath = distortPath(textPath, time: currentTime)
                    
                    // MARK: - Rendering
                    
                    var flipTransform = CGAffineTransform(translationX: 0, y: size.height)
                    flipTransform = flipTransform.scaledBy(x: 1, y: -1)
                    
                    if let flippedPath = distortedPath.copy(using: &flipTransform) {
                        let boundingBox = flippedPath.boundingBox
                        let offsetX = (size.width - boundingBox.width) / 2 - boundingBox.minX
                        var translateTransform = CGAffineTransform(translationX: offsetX, y: 0)
                        
                        if let centeredPath = flippedPath.copy(using: &translateTransform) {
                            context.fill(Path(centeredPath), with: .color(fillColor))
                        }
                    }
                }
            }
        }
    }
}

private extension DistortedTextColumn {
    func distortPath(_ path: CGPath, time: Double) -> CGPath {
        let mutablePath = CGMutablePath()
        
        path.applyWithBlock { elementPointer in
            let element = elementPointer.pointee
            
            switch element.type {
            case .moveToPoint:
                var point = element.points[0]
                point.y += amplitude * sin(frequency * point.x + speed * CGFloat(time))
                mutablePath.move(to: point)
                
            case .addLineToPoint:
                var point = element.points[0]
                point.y += amplitude * sin(frequency * point.x + speed * CGFloat(time))
                mutablePath.addLine(to: point)
                
            case .addQuadCurveToPoint:
                var control = element.points[0]
                var point = element.points[1]
                control.y += amplitude * sin(frequency * control.x + speed * CGFloat(time))
                point.y += amplitude * sin(frequency * point.x + speed * CGFloat(time))
                mutablePath.addQuadCurve(to: point, control: control)
                
            case .addCurveToPoint:
                var control1 = element.points[0]
                var control2 = element.points[1]
                var point = element.points[2]
                control1.y += amplitude * sin(frequency * control1.x + speed * CGFloat(time))
                control2.y += amplitude * sin(frequency * control2.x + speed * CGFloat(time))
                point.y += amplitude * sin(frequency * point.x + speed * CGFloat(time))
                mutablePath.addCurve(to: point, control1: control1, control2: control2)
                
            case .closeSubpath:
                mutablePath.closeSubpath()
                
            @unknown default:
                break
            }
        }
        
        return mutablePath
    }
}

#Preview {
    DistortedTextColumn(
        text: """
        This is a sample multiline text that should wrap inside a fixed column width. The text will be rendered using Core Text APIs inside a SwiftUI Canvas, ensuring proper layout and wrapping.

        SwiftUI Canvas combined with Core Text allows precise control over text rendering.
        """,
        amplitude: 50,
        frequency: 0.02,
        speed: 2,
        columnWidth: 500,
        fontSize: 80,
        fillColor: .black
    )
    .frame(width: .infinity, height: .infinity)
    .background(Color.white)
}
