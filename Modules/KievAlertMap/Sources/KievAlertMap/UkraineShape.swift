import SwiftUI

/// A simple stylized silhouette for the "static map" demo.
/// Not geographically accurate; serves as a stable canvas for oblast dots.
struct UkraineShape: Shape {
    func path(in rect: CGRect) -> Path {
        // Hand-tuned polygon in normalized coordinates.
        let points: [CGPoint] = [
            CGPoint(x: 0.18, y: 0.42),
            CGPoint(x: 0.28, y: 0.30),
            CGPoint(x: 0.46, y: 0.20),
            CGPoint(x: 0.70, y: 0.24),
            CGPoint(x: 0.86, y: 0.38),
            CGPoint(x: 0.82, y: 0.50),
            CGPoint(x: 0.90, y: 0.62),
            CGPoint(x: 0.78, y: 0.74),
            CGPoint(x: 0.64, y: 0.82),
            CGPoint(x: 0.60, y: 0.92),
            CGPoint(x: 0.48, y: 0.82),
            CGPoint(x: 0.34, y: 0.86),
            CGPoint(x: 0.22, y: 0.76),
            CGPoint(x: 0.26, y: 0.60),
            CGPoint(x: 0.14, y: 0.52)
        ]

        func p(_ n: CGPoint) -> CGPoint {
            CGPoint(x: rect.minX + n.x * rect.width, y: rect.minY + n.y * rect.height)
        }

        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: p(first))
        for point in points.dropFirst() {
            path.addLine(to: p(point))
        }
        path.closeSubpath()
        return path
    }
}

