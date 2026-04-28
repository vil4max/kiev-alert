import Foundation
import KievAlertDomain

public struct FetchAllRegionStatusesUseCase: Sendable {
    private let provider: any AirAlertProviding
    private let now: @Sendable () -> Date

    public init(provider: any AirAlertProviding, now: @escaping @Sendable () -> Date = Date.init) {
        self.provider = provider
        self.now = now
    }

    public func execute() async throws -> [AlertStatusSnapshot] {
        let snapshots = try await provider.fetchAllOblastStatuses()
        let checkedAt = now()
        return snapshots.map { snapshot in
            AlertStatusSnapshot(
                region: snapshot.region,
                status: snapshot.status,
                checkedAt: checkedAt,
                source: snapshot.source
            )
        }
    }
}

