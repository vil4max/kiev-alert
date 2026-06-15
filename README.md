# KievAlert (public demo)

SwiftUI iOS app for **air-raid alert status** by region. Long-term goal: **CarPlay** — a glanceable ALARM / QUIET experience on the car screen without digging into the phone.

The app shows alert status for the **selected region** (auto-detected via location) and a **Map** tab with region status markers.

## Future work

- Use Apple Maps on CarPlay to show the driver’s position and highlight (fill) the current region based on the alert status.

## Data source

- Data source: `ubilling.net.ua/aerialalerts/` (public JSON proxy).
- Disclaimer: this is a demo project. Availability/accuracy is not guaranteed. This is not an official source.

## Architecture

Clean-ish layering (kept intentionally small):

- **Domain (SPM)**: `Modules/KievAlertDomain`
  - models: `AlertRegion`, `AlertStatus`, `AlertStatusSnapshot`
  - protocol: `AirAlertProviding`
- **Data (SPM)**: `Modules/KievAlertData`
  - `UbillingAirAlertProvider: AirAlertProviding`
  - `HTTPClient` abstraction (`URLSession` conforms)
  - ubilling DTOs / decoding
- **Status UI (SPM)**: `Modules/KievAlertStatus`
  - `KievAlertStatusView` + `KievAlertViewModel`
  - use cases: `FetchAlertStatusUseCase`, `RegionTitleUseCase`
- **Map UI (SPM)**: `Modules/KievAlertMap`
  - `UkraineMapView` + `UkraineMapViewModel`
  - use case: `FetchAllRegionStatusesUseCase`
- **App (Xcode target / composition root)**: `KievAlert/`
  - composes modules in `AppCoordinator`

## Localization

- Uses **String Catalogs**: `KievAlert/Resources/Localizable.xcstrings`
- Languages: **EN / RU / UK**

## Technologies

- **Swift / SwiftUI**
- **Swift Concurrency** (`async/await`, `Task`)
- **SPM (Swift Package Manager)**: local packages for Domain/Data modules
- **Networking**: `URLSession` + JSON decoding (`Decodable`)
- **MapKit**: interactive map + custom annotations for region statuses
- **CoreLocation**: user location + reverse geocoding for auto region selection
- **Localization**: `.xcstrings` (String Catalog)
- **Testing**: Swift Testing framework (`import Testing`)
- **CarPlay**: `CPTemplateApplicationSceneDelegate` (best-effort demo)

## CarPlay

The project includes a CarPlay scene delegate (best-effort demo in code). With a **Personal Team**, the app may not appear in CarPlay “Customize” due to Apple’s CarPlay entitlement/capability requirements.

## Run

- Open `KievAlert.xcodeproj`
- Select the `KievAlert` scheme
- Build & Run on a simulator

## Tests

- Domain/Data/UI modules are tested in the SPM modules and the Xcode unit test target (`KievAlertTests`).

