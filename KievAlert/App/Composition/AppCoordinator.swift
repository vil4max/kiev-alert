import Foundation
import KievAlertData
import KievAlertMap
import KievAlertStatus
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    enum Tab {
        case region
        case map
    }

    let locationManager: UserLocationManager
    let regionSelection: RegionSelectionViewModel
    let alertViewModel: KievAlertViewModel
    let mapViewModel: UkraineMapViewModel

    @Published var selectedTab: Tab = .region
    @Published var presentedErrorMessage: String?

    private var didStart = false
    @Published private(set) var canPresentErrors: Bool = false

    init(provider: UbillingAirAlertProvider = sharedProvider) {
        self.locationManager = UserLocationManager()

        let fetchStatus = FetchAlertStatusUseCase(provider: provider)
        let fetchAll = FetchAllRegionStatusesUseCase(provider: provider)

        let alertVM = KievAlertViewModel(region: .kyivCity, fetchStatus: fetchStatus)
        self.alertViewModel = alertVM
        self.mapViewModel = UkraineMapViewModel(fetchAll: fetchAll)

        self.regionSelection = RegionSelectionViewModel { region, _ in
            Task { @MainActor in
                alertVM.setRegion(region)
            }
        }
    }

    func onAppear() {
        locationManager.requestAuthorizationIfNeeded()

        guard !didStart else { return }
        didStart = true

        alertViewModel.refresh()
        mapViewModel.refresh()
    }

    func refreshCurrentTab() {
        canPresentErrors = true
        switch selectedTab {
        case .region:
            alertViewModel.refresh()
        case .map:
            mapViewModel.refresh()
        }
    }

    func clearPresentedError() {
        presentedErrorMessage = nil
        alertViewModel.clearError()
        mapViewModel.clearError()
    }
}

