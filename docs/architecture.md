# Architecture

Clean-ish layering (kept intentionally small):

## Domain (SPM)

`Modules/KievAlertDomain`

- models: `AlertRegion`, `AlertStatus`, `AlertStatusSnapshot`
- protocol: `AirAlertProviding`

## Data (SPM)

`Modules/KievAlertData`

- `UbillingAirAlertProvider: AirAlertProviding`
- `HTTPClient` abstraction (`URLSession` conforms)
- ubilling DTOs / decoding

## Status UI (SPM)

`Modules/KievAlertStatus`

- `KievAlertStatusView` + `KievAlertViewModel`
- use cases: `FetchAlertStatusUseCase`, `RegionTitleUseCase`

## Map UI (SPM)

`Modules/KievAlertMap`

- `UkraineMapView` + `UkraineMapViewModel`
- use case: `FetchAllRegionStatusesUseCase`

## App (Xcode target)

`KievAlert/` — composes modules in `AppCoordinator`

## Data source

- Public JSON proxy: `ubilling.net.ua/aerialalerts/`
- Demo project — availability and accuracy not guaranteed; not an official source.

## CarPlay

`CPTemplateApplicationSceneDelegate` (best-effort demo). With a Personal Team, the app may not appear in CarPlay Customize due to Apple entitlement requirements.

## Future work

Use Apple Maps on CarPlay to show the driver's position and highlight the current region based on alert status.

## Localization

String Catalogs: `KievAlert/Resources/Localizable.xcstrings` — EN / RU / UK.

## Run and tests

- Open `KievAlert.xcodeproj`, scheme `KievAlert`, build and run on simulator.
- Domain/Data/UI modules tested in SPM modules and `KievAlertTests`.
