import CoreLocation

public enum UkraineOblastCoordinates {
    // Approximate centers (mostly oblast capitals). Keys match ubilling `states` keys.
    public static let byUbillingKey: [String: CLLocationCoordinate2D] = [
        "Вінницька область": CLLocationCoordinate2D(latitude: 49.2331, longitude: 28.4682),
        "Волинська область": CLLocationCoordinate2D(latitude: 50.7472, longitude: 25.3254),
        "Дніпропетровська область": CLLocationCoordinate2D(latitude: 48.4647, longitude: 35.0462),
        "Донецька область": CLLocationCoordinate2D(latitude: 48.0159, longitude: 37.8029),
        "Житомирська область": CLLocationCoordinate2D(latitude: 50.2547, longitude: 28.6587),
        "Закарпатська область": CLLocationCoordinate2D(latitude: 48.6208, longitude: 22.2879),
        "Запорізька область": CLLocationCoordinate2D(latitude: 47.8388, longitude: 35.1396),
        "Івано-Франківська область": CLLocationCoordinate2D(latitude: 48.9226, longitude: 24.7111),
        "Київська область": CLLocationCoordinate2D(latitude: 50.4501, longitude: 30.5234),
        "Кіровоградська область": CLLocationCoordinate2D(latitude: 48.5079, longitude: 32.2623),
        "Луганська область": CLLocationCoordinate2D(latitude: 48.5740, longitude: 39.3078),
        "Львівська область": CLLocationCoordinate2D(latitude: 49.8397, longitude: 24.0297),
        "Миколаївська область": CLLocationCoordinate2D(latitude: 46.9750, longitude: 31.9946),
        "Одеська область": CLLocationCoordinate2D(latitude: 46.4825, longitude: 30.7233),
        "Полтавська область": CLLocationCoordinate2D(latitude: 49.5883, longitude: 34.5514),
        "Рівненська область": CLLocationCoordinate2D(latitude: 50.6199, longitude: 26.2516),
        "Сумська область": CLLocationCoordinate2D(latitude: 50.9077, longitude: 34.7981),
        "Тернопільська область": CLLocationCoordinate2D(latitude: 49.5535, longitude: 25.5948),
        "Харківська область": CLLocationCoordinate2D(latitude: 49.9935, longitude: 36.2304),
        "Херсонська область": CLLocationCoordinate2D(latitude: 46.6354, longitude: 32.6169),
        "Хмельницька область": CLLocationCoordinate2D(latitude: 49.4220, longitude: 26.9871),
        "Черкаська область": CLLocationCoordinate2D(latitude: 49.4444, longitude: 32.0598),
        "Чернівецька область": CLLocationCoordinate2D(latitude: 48.2915, longitude: 25.9403),
        "Чернігівська область": CLLocationCoordinate2D(latitude: 51.4982, longitude: 31.2893),
        "АР Крим": CLLocationCoordinate2D(latitude: 44.9521, longitude: 34.1024),
        "м. Київ": CLLocationCoordinate2D(latitude: 50.4501, longitude: 30.5234)
    ]

    // What we show as the annotation title (capital / regional center).
    public static let capitalTitleByUbillingKey: [String: String] = [
        "Вінницька область": "Вінниця",
        "Волинська область": "Луцьк",
        "Дніпропетровська область": "Дніпро",
        "Донецька область": "Донецьк",
        "Житомирська область": "Житомир",
        "Закарпатська область": "Ужгород",
        "Запорізька область": "Запоріжжя",
        "Івано-Франківська область": "Івано-Франківськ",
        "Київська область": "Київ",
        "Кіровоградська область": "Кропивницький",
        "Луганська область": "Луганськ",
        "Львівська область": "Львів",
        "Миколаївська область": "Миколаїв",
        "Одеська область": "Одеса",
        "Полтавська область": "Полтава",
        "Рівненська область": "Рівне",
        "Сумська область": "Суми",
        "Тернопільська область": "Тернопіль",
        "Харківська область": "Харків",
        "Херсонська область": "Херсон",
        "Хмельницька область": "Хмельницький",
        "Черкаська область": "Черкаси",
        "Чернівецька область": "Чернівці",
        "Чернігівська область": "Чернігів",
        "АР Крим": "Сімферополь",
        "м. Київ": "Київ"
    ]
}

