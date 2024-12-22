import Vapor

public struct HXLocalisations: Sendable {
    public var providers: [String: any Sendable] //HXLocalisable]
    public var defaultLanguageCode: String
    public var overrideLanguagePreference: (@Sendable (_ req: Request) -> String?)?

    public func localise(text: String, for code: String) -> String {
        guard !code.isEmpty else { return text }

		if let localisation = providers[code] as? HXLocalisable {
            return localisation.localise(text: text)
		} else if let moreGeneralCode = HXLocalisations.generaliseLang(code: code), let localisation = providers[moreGeneralCode] as? HXLocalisable{
            return localisation.localise(text: text)
        }

        return text
    }

    public init(providers: [String: any HXLocalisable], defaultLanguageCode: String? = nil, overrideLanguagePreference: (@Sendable (_: Request) -> String?)? = nil) {
        self.providers = providers
        self.overrideLanguagePreference = overrideLanguagePreference
		self.defaultLanguageCode = defaultLanguageCode ?? Locale.current.language.languageCode?.identifier ?? "en"
    }

    public static func generaliseLang(code: String) -> String? {
        guard !code.isEmpty else { return nil }

        for (i, c) in code.enumerated() {
            if c == "-" {
                if i > 1, i < 4 {
                    return String(code[...code.index(code.startIndex, offsetBy: i - 1)])
                } else {
                    return nil
                }
            } else if i > 3 {
                return nil
            }
        }

        return code
    }
}

public extension HXLocalisations {
    init() {
        providers = [:]
        overrideLanguagePreference = nil
		defaultLanguageCode = Locale.current.language.languageCode?.identifier ?? "en"
    }
}
