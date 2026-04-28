import CoreLocation

enum LocationAuthorization {
    static func requestWhenInUseIfNeeded() {
        let manager = CLLocationManager()
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
}

