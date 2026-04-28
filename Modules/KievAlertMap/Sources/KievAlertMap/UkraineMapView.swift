import KievAlertDomain
import MapKit
import SwiftUI
import os

private enum UkraineBorder {
    static let rings: [[CLLocationCoordinate2D]] = {
        guard let url = Bundle.module.url(forResource: "ukraine", withExtension: "geojson"),
              let data = try? Data(contentsOf: url)
        else {
            return []
        }

        let decoder = MKGeoJSONDecoder()
        let objects: [MKGeoJSONObject]
        do {
            objects = try decoder.decode(data)
        } catch {
            return []
        }

        var result: [[CLLocationCoordinate2D]] = []

        func appendRing(from polygon: MKPolygon) {
            // `polygon.points()` returns MKMapPoint array; convert to coordinates.
            let points = polygon.points()
            guard polygon.pointCount > 1 else { return }

            var coords = Array(repeating: CLLocationCoordinate2D(latitude: 0, longitude: 0), count: polygon.pointCount)
            for i in 0..<polygon.pointCount {
                coords[i] = points[i].coordinate
            }
            result.append(coords)
        }

        for object in objects {
            guard let feature = object as? MKGeoJSONFeature else { continue }
            for geometry in feature.geometry {
                if let polygon = geometry as? MKPolygon {
                    appendRing(from: polygon)
                } else if let multiPolygon = geometry as? MKMultiPolygon {
                    for polygon in multiPolygon.polygons {
                        appendRing(from: polygon)
                    }
                }
            }
        }

        return result
    }()
}

private enum UkraineRegionBorders {
    private static let log = Logger(subsystem: "vil4max.KievAlert", category: "KievAlertMap")

    static let rings: [[CLLocationCoordinate2D]] = {
        guard let url = Bundle.module.url(forResource: "ukraine_oblasts", withExtension: "geojson"),
              let data = try? Data(contentsOf: url)
        else {
            log.error("Failed to load ukraine_oblasts.geojson from Bundle.module")
            return []
        }

        let decoder = MKGeoJSONDecoder()
        let objects: [MKGeoJSONObject]
        do {
            objects = try decoder.decode(data)
        } catch {
            log.error("Failed to decode ukraine_oblasts.geojson: \(String(describing: error), privacy: .public)")
            return []
        }

        var result: [[CLLocationCoordinate2D]] = []

        func appendRing(from polygon: MKPolygon) {
            let points = polygon.points()
            guard polygon.pointCount > 1 else { return }

            var coords = Array(repeating: CLLocationCoordinate2D(latitude: 0, longitude: 0), count: polygon.pointCount)
            for i in 0..<polygon.pointCount {
                coords[i] = points[i].coordinate
            }
            result.append(coords)
        }

        for object in objects {
            guard let feature = object as? MKGeoJSONFeature else { continue }
            for geometry in feature.geometry {
                if let polygon = geometry as? MKPolygon {
                    appendRing(from: polygon)
                } else if let multiPolygon = geometry as? MKMultiPolygon {
                    for polygon in multiPolygon.polygons {
                        appendRing(from: polygon)
                    }
                }
            }
        }

        log.error("Decoded region borders rings: \(result.count, privacy: .public)")
        return result
    }()
}

@MainActor
public final class UkraineMapViewModel: ObservableObject {
    private static let log = Logger(subsystem: "vil4max.KievAlert", category: "KievAlertMap")

    @Published private(set) var snapshots: [AlertStatusSnapshot] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String?

    private let fetchAll: FetchAllRegionStatusesUseCase

    public init(fetchAll: FetchAllRegionStatusesUseCase) {
        self.fetchAll = fetchAll
    }

    public func refresh() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        Task {
            let result: Result<[AlertStatusSnapshot], Error>
            do {
                let snapshots = try await Self.withTimeout(seconds: 12) {
                    try await self.fetchAll.execute()
                }
                result = .success(snapshots)
            } catch {
                result = .failure(error)
            }

            switch result {
            case .success(let snapshots):
                self.snapshots = snapshots
            case .failure(let error):
                let technical = String(describing: error)
                Self.log.error("Fetch all regions failed: \(technical, privacy: .public)")
                self.errorMessage = error.localizedDescription
            }

            self.isLoading = false
        }
    }

    public func clearError() {
        errorMessage = nil
    }

    private static func withTimeout<T: Sendable>(
        seconds: TimeInterval,
        operation: @escaping @Sendable () async throws -> T
    ) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                try await operation()
            }
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(seconds) * 1_000_000_000)
                throw TimeoutError()
            }
            let value = try await group.next()!
            group.cancelAll()
            return value
        }
    }

    private struct TimeoutError: Error, Sendable {}
}

public struct UkraineMapView: View {
    @ObservedObject private var viewModel: UkraineMapViewModel

    private static let initialRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.0, longitude: 31.0),
        span: MKCoordinateSpan(latitudeDelta: 11.0, longitudeDelta: 18.0)
    )
    @State private var cameraPosition: MapCameraPosition = .region(initialRegion)

    private static let bottomControlsPadding: CGFloat = 92

    public init(viewModel: UkraineMapViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Map(
            position: $cameraPosition,
            interactionModes: .all
        ) {
            ForEach(markers) { marker in
                Annotation(marker.title, coordinate: marker.coordinate) {
                    Circle()
                        .fill(marker.color)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(.white.opacity(0.9), lineWidth: 2))
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                        .accessibilityHidden(true)
                }
            }

            ForEach(Array(UkraineBorder.rings.enumerated()), id: \.offset) { _, ring in
                MapPolyline(MKPolyline(coordinates: ring, count: ring.count))
                    .stroke(.yellow, lineWidth: 3.5)
                    .foregroundStyle(.yellow)
            }

            ForEach(Array(UkraineRegionBorders.rings.enumerated()), id: \.offset) { _, ring in
                MapPolyline(MKPolyline(coordinates: ring, count: ring.count))
                    .stroke(.yellow.opacity(0.55), lineWidth: 1.1)
                    .foregroundStyle(.yellow.opacity(0.55))
            }

            UserAnnotation()
        }
        .ignoresSafeArea()
        .mapControls {
            MapCompass()
        }
        .overlay(alignment: .bottomLeading) {
            MapUserLocationButton()
                .padding(.leading, 16)
                .padding(.bottom, Self.bottomControlsPadding)
        }
        .onAppear {
            LocationAuthorization.requestWhenInUseIfNeeded()
        }
    }

    public func centerOnUser() {
        LocationAuthorization.requestWhenInUseIfNeeded()
        cameraPosition = .userLocation(fallback: .region(Self.initialRegion))
    }

    private var markers: [Marker] {
        viewModel.snapshots.compactMap { snapshot in
            let name: String
            switch snapshot.region.kind {
            case .oblast(let oblastName):
                name = oblastName
            case .kyivCity:
                name = "м. Київ"
            }

            guard let coordinate = UkraineOblastCoordinates.byUbillingKey[name] else { return nil }
            let title = UkraineOblastCoordinates.capitalTitleByUbillingKey[name] ?? name
            let color: Color = (snapshot.status == .alarm) ? .red : .green
            return Marker(id: name, title: title, coordinate: coordinate, color: color)
        }
    }

    private struct Marker: Identifiable {
        let id: String
        let title: String
        let coordinate: CLLocationCoordinate2D
        let color: Color
    }
}

