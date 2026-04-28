import SwiftUI
import KievAlertData
import KievAlertStatus
import KievAlertMap

struct ContentView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                KievAlertStatusView(viewModel: coordinator.alertViewModel)
                    .opacity(coordinator.selectedTab == .region ? 1 : 0)
                    .allowsHitTesting(coordinator.selectedTab == .region)

                UkraineMapView(viewModel: coordinator.mapViewModel)
                    .opacity(coordinator.selectedTab == .map ? 1 : 0)
                    .allowsHitTesting(coordinator.selectedTab == .map)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if isShowingLoader {
                loaderOverlay
                    .transition(.opacity)
            }

            tabBar
        }
        .onAppear {
            coordinator.onAppear()
        }
        .onChange(of: coordinator.locationManager.coordinateStamp) { _, _ in
            guard let coordinate = coordinator.locationManager.coordinate else { return }
            coordinator.regionSelection.updateFromLocation(coordinate: coordinate)
            coordinator.locationManager.stop()
        }
        .onChange(of: coordinator.alertViewModel.errorMessage) { _, newValue in
            guard let newValue else { return }
            guard coordinator.canPresentErrors else { return }
            coordinator.presentedErrorMessage = newValue
        }
        .onChange(of: coordinator.mapViewModel.errorMessage) { _, newValue in
            guard let newValue else { return }
            guard coordinator.canPresentErrors else { return }
            coordinator.presentedErrorMessage = newValue
        }
        .alert(String(localized: "Error"), isPresented: Binding(get: {
            coordinator.presentedErrorMessage != nil
        }, set: { newValue in
            guard !newValue else { return }
            coordinator.clearPresentedError()
        })) {
            Button(String(localized: "OK")) {}
        } message: {
            Text(coordinator.presentedErrorMessage ?? "")
        }
    }

    private var tabBar: some View {
        HStack(spacing: 12) {
            segmentedPill
            circularRefreshButton
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.clear)
    }

    private var segmentedPill: some View {
        HStack(spacing: 0) {
            pillTabButton(
                title: coordinator.regionSelection.selectedRegionTitle,
                isSelected: coordinator.selectedTab == .region
            ) {
                coordinator.selectedTab = .region
            }

            pillTabButton(
                title: String(localized: "Map"),
                isSelected: coordinator.selectedTab == .map
            ) {
                coordinator.selectedTab = .map
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.22), radius: 10, x: 0, y: 4)
        .frame(maxWidth: .infinity)
    }

    private var circularRefreshButton: some View {
        Button {
            coordinator.refreshCurrentTab()
        } label: {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.ultraThinMaterial, in: Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.14), lineWidth: 1))
                .shadow(color: .black.opacity(0.22), radius: 10, x: 0, y: 4)
        }
        .disabled(isShowingLoader)
        .accessibilityLabel(Text("Refresh"))
    }

    private var isShowingLoader: Bool {
        switch coordinator.selectedTab {
        case .region:
            return coordinator.alertViewModel.isLoading
        case .map:
            return coordinator.mapViewModel.isLoading
        }
    }

    private var loaderOverlay: some View {
        ZStack {
            Color.black.opacity(0.28)
                .ignoresSafeArea()

            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
                .scaleEffect(1.2)
                .padding(20)
                .background(Color.black.opacity(0.35), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
        }
        .allowsHitTesting(true)
        .accessibilityAddTraits(.isModal)
    }

    private func pillTabButton(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(1)
            .foregroundStyle(.white.opacity(isSelected ? 1.0 : 0.55))
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.black.opacity(0.28))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.white.opacity(0.10), lineWidth: 1)
                        )
                }
            }
        }
        .buttonStyle(.plain)
    }

}

#Preview {
    ContentView(coordinator: AppCoordinator())
}

