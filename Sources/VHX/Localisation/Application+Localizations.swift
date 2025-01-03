import Vapor
@preconcurrency import Lingo

extension Lingo: @unchecked @retroactive Sendable {}

public extension Application {
    struct LocalizationStorageKey: StorageKey, Sendable {
        public typealias Value = Lingo
    }

    var localizations: Lingo {
        get {
			if storage[LocalizationStorageKey.self] == nil {
				fatalError("Localizations not defined")
			}
			return storage[LocalizationStorageKey.self]!
        }
        set {
            if storage[LocalizationStorageKey.self] == nil {
                storage[LocalizationStorageKey.self] = newValue
            } else {
                fatalError("Redeclaration of Localizations")
            }
        }
    }
}
