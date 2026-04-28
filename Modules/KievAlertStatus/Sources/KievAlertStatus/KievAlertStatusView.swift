import SwiftUI
import KievAlertDomain
import os

@MainActor
public enum AlertStatusViewState: Equatable, Sendable {
    case idle
    case quiet(lastCheckedAt: Date, source: String)
    case alarm(lastCheckedAt: Date, source: String)
    case error(message: String)
}

@MainActor
public final class KievAlertViewModel: ObservableObject {
    private static let log = Logger(subsystem: "vil4max.KievAlert", category: "KievAlertStatus")

    @Published public private(set) var state: AlertStatusViewState = .idle
    @Published public private(set) var regionTitle: String
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String?

    private var region: AlertRegion
    private let fetchStatus: FetchAlertStatusUseCase
    private let regionTitleUseCase: RegionTitleUseCase

    public init(
        region: AlertRegion,
        fetchStatus: FetchAlertStatusUseCase,
        regionTitleUseCase: RegionTitleUseCase = .init()
    ) {
        self.region = region
        self.fetchStatus = fetchStatus
        self.regionTitleUseCase = regionTitleUseCase
        self.regionTitle = regionTitleUseCase.execute(region: region)
    }

    public func setRegion(_ region: AlertRegion) {
        self.region = region
        self.regionTitle = regionTitleUseCase.execute(region: region)
    }

    public func refresh() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        Task {
            defer { isLoading = false }
            do {
                let snapshot = try await fetchStatus.execute(region: region)
                switch snapshot.status {
                case .alarm:
                    state = .alarm(lastCheckedAt: snapshot.checkedAt, source: snapshot.source)
                case .quiet:
                    state = .quiet(lastCheckedAt: snapshot.checkedAt, source: snapshot.source)
                }
            } catch {
                Self.log.error("Fetch status failed: \(error.localizedDescription, privacy: .public)")
                let userMessage = error.localizedDescription
                state = .error(message: userMessage)
                errorMessage = userMessage
            }
        }
    }

    public func clearError() {
        errorMessage = nil
    }
}

public struct KievAlertStatusView: View {
    @ObservedObject private var viewModel: KievAlertViewModel

    public init(viewModel: KievAlertViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 14) {
                Text(titleText)
                    .font(.system(size: 30, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                
                Text(emojiText)
                    .font(.system(size: 92))
                    .accessibilityHidden(true)
            }
        }
    }
    
    private var backgroundColor: Color {
        switch viewModel.state {
        case .alarm:
            return .red
        case .quiet:
            return .green
        case .idle, .error:
            return .gray
        }
    }
    
    private var titleText: String {
        switch viewModel.state {
        case .alarm:
            return String(format: String(localized: "ALARM in %@"), viewModel.regionTitle)
        case .quiet:
            return String(format: String(localized: "QUIET in %@"), viewModel.regionTitle)
        case .idle:
            return String(localized: "Checking…")
        case .error:
            return String(localized: "Error. Tap Refresh")
        }
    }
    
    private var emojiText: String {
        switch viewModel.state {
        case .alarm:
            return "🚨"
        case .quiet:
            return "😌"
        case .idle:
            return "⏳"
        case .error:
            return "⚠️"
        }
    }
}

#Preview {
    let useCase = FetchAlertStatusUseCase(provider: PreviewProvider())
    KievAlertStatusView(viewModel: KievAlertViewModel(region: .kyivCity, fetchStatus: useCase))
}

private struct PreviewProvider: AirAlertProviding {
    func fetchStatus(region: AlertRegion) async throws -> AlertStatusSnapshot {
        AlertStatusSnapshot(region: region, status: .quiet, checkedAt: Date(), source: "preview")
    }

    func fetchAllOblastStatuses() async throws -> [AlertStatusSnapshot] {
        []
    }
}

