import Vapor

public struct HXRequestLocalization {
    let req: Request

    public func localize(text: String, interpolations: [String: Any]? = nil, for code: String? = nil) -> String {
        let code = code ?? prefered

		return req.application.localizations.localize(text, locale: code, interpolations: interpolations)
    }

    public var prefered: String {
//        if let overrideLanguagePreference = req.application.localizations.overrideLanguagePreference,
//           let code = overrideLanguagePreference(req)
//        {
//            code
//        } else {
		req.headers.language(fallback: req.application.localizations.defaultLocale).prefered
//        }
    }
}
