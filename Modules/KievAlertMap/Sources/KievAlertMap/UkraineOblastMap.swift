import CoreGraphics

public enum UkraineRegionMap {
    // Coordinates are relative (0...1) within the rendered Ukraine shape bounds.
    // Keys are ubilling `states` dictionary keys.
    public static let pointByUbillingKey: [String: CGPoint] = [
        "Вінницька область": CGPoint(x: 0.44, y: 0.56),
        "Волинська область": CGPoint(x: 0.31, y: 0.30),
        "Дніпропетровська область": CGPoint(x: 0.62, y: 0.56),
        "Донецька область": CGPoint(x: 0.75, y: 0.60),
        "Житомирська область": CGPoint(x: 0.44, y: 0.39),
        "Закарпатська область": CGPoint(x: 0.20, y: 0.50),
        "Запорізька область": CGPoint(x: 0.68, y: 0.69),
        "Івано-Франківська область": CGPoint(x: 0.26, y: 0.52),
        "Київська область": CGPoint(x: 0.50, y: 0.41),
        "Кіровоградська область": CGPoint(x: 0.55, y: 0.59),
        "Луганська область": CGPoint(x: 0.83, y: 0.54),
        "Львівська область": CGPoint(x: 0.24, y: 0.43),
        "Миколаївська область": CGPoint(x: 0.55, y: 0.76),
        "Одеська область": CGPoint(x: 0.42, y: 0.82),
        "Полтавська область": CGPoint(x: 0.60, y: 0.46),
        "Рівненська область": CGPoint(x: 0.40, y: 0.29),
        "Сумська область": CGPoint(x: 0.66, y: 0.30),
        "Тернопільська область": CGPoint(x: 0.32, y: 0.48),
        "Харківська область": CGPoint(x: 0.76, y: 0.40),
        "Херсонська область": CGPoint(x: 0.62, y: 0.85),
        "Хмельницька область": CGPoint(x: 0.38, y: 0.50),
        "Черкаська область": CGPoint(x: 0.54, y: 0.52),
        "Чернівецька область": CGPoint(x: 0.33, y: 0.61),
        "Чернігівська область": CGPoint(x: 0.57, y: 0.24),
        "АР Крим": CGPoint(x: 0.70, y: 0.96),
        "м. Київ": CGPoint(x: 0.50, y: 0.44)
    ]
}

