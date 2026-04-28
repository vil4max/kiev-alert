import CarPlay
import SwiftUI
import UIKit
import KievAlertDomain
import KievAlertStatus

final class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    private var interfaceController: CPInterfaceController?
    private var state: AlertStatusViewState = .idle
    
    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController,
        to window: CPWindow
    ) {
        self.interfaceController = interfaceController
        
        // Fetch once on open (MVP).
        Task {
            await refreshOnce()
            await render()
        }
        
        Task { @MainActor in
            await setRootTemplateSafely(interfaceController, state: .idle, animated: false)
        }
    }
    
    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didDisconnect interfaceController: CPInterfaceController,
        from window: CPWindow
    ) {
        self.interfaceController = nil
    }
    
    @MainActor
    private func render() async {
        guard let interfaceController else { return }
        let regionTitle = RegionTitleUseCase().execute(region: persistedRegion())
        await setRootTemplateSafely(interfaceController, state: state, regionTitle: regionTitle, animated: true)
    }

    @MainActor
    private func setRootTemplateSafely(
        _ interfaceController: CPInterfaceController,
        state: AlertStatusViewState,
        regionTitle: String = "Kyiv",
        animated: Bool
    ) async {
        do {
            try await interfaceController.setRootTemplate(makeRootTemplate(state: state, regionTitle: regionTitle), animated: animated)
        } catch {
            // best-effort for MVP
        }
    }
    
    private func makeRootTemplate(state: AlertStatusViewState, regionTitle: String) -> CPListTemplate {
        let (statusText, detailText) = statusStrings(for: state, regionTitle: regionTitle)
        
        let statusItem = CPListItem(text: statusText, detailText: detailText)
        statusItem.isEnabled = false
        
        let refreshItem = CPListItem(text: NSLocalizedString("Refresh", comment: ""), detailText: nil)
        refreshItem.handler = { [weak self] _, completion in
            guard let self else { completion(); return }
            Task {
                await self.refreshOnce()
                await self.render()
                completion()
            }
        }
        
        let section = CPListSection(items: [statusItem, refreshItem])
        let template = CPListTemplate(title: NSLocalizedString("Kiev Alert", comment: ""), sections: [section])
        template.tabTitle = NSLocalizedString("Alert", comment: "")
        template.tabImage = UIImage(systemName: "exclamationmark.triangle")
        return template
    }
    
    private func statusStrings(for state: AlertStatusViewState, regionTitle: String) -> (String, String?) {
        switch state {
        case .idle:
            return (String(localized: "Checking…"), nil)
        case .alarm(let lastCheckedAt, _):
            let title = String(format: String(localized: "ALARM in %@"), regionTitle) + " 🚨"
            let detail = String(format: String(localized: "Updated: %@"), format(lastCheckedAt))
            return (title, detail)
        case .quiet(let lastCheckedAt, _):
            let title = String(format: String(localized: "QUIET in %@"), regionTitle) + " 😌"
            let detail = String(format: String(localized: "Updated: %@"), format(lastCheckedAt))
            return (title, detail)
        case .error:
            return (String(localized: "Error"), String(localized: "Error. Tap Refresh"))
        }
    }
    
    private func format(_ date: Date) -> String {
        date.formatted(date: .omitted, time: .shortened)
    }

    private func refreshOnce() async {
        do {
            let snapshot = try await sharedFetchStatusUseCase.execute(region: persistedRegion())
            switch snapshot.status {
            case .alarm:
                state = .alarm(lastCheckedAt: snapshot.checkedAt, source: snapshot.source)
            case .quiet:
                state = .quiet(lastCheckedAt: snapshot.checkedAt, source: snapshot.source)
            }
        } catch {
            state = .error(message: String(describing: error))
        }
    }

    private func persistedRegion() -> AlertRegion {
        SelectedRegionPersistence.shared.load()?.region ?? .kyivCity
    }
}

