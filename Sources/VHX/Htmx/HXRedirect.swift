import Vapor

public struct HXRedirect {
    public enum Kind {
        case replacePage
        case pushPage
        case rplaceFragment
        case pushFragment
    }

    let location: String
    let htmlKind: Redirect
    let htmxKind: Kind

    init(to location: String, htmx: Kind = .pushFragment, html: Redirect = .normal) {
        if location.isEmpty {
            self.location = "/"
        } else {
            self.location = location
        }
        htmlKind = html
        htmxKind = htmx
    }
}

extension HXRedirect: AsyncResponseEncodable {
    public func encodeResponse(for request: Request) async throws -> Response {
        switch request.htmx.prefers {
        case .html:
            return request.redirect(to: location, redirectType: htmlKind)
        default:
            let responce = Response(status: .noContent)
            var headers = HXResponseHeaders()
            switch htmxKind {
            case .pushFragment:
                headers.location = HXLocationHeader(location)
            case .rplaceFragment:
                headers.location = HXLocationHeader(location)
                headers.replaceUrl = HXReplaceUrlHeader()
            case .pushPage:
                headers.redirect = HXRedirectHeader(location: location)
            case .replacePage:
                headers.redirect = HXRedirectHeader(location: location)
                headers.replaceUrl = HXReplaceUrlHeader()
            }
            return responce
        }
    }

    public static func auto(from req: Request, key _: String = "next", htmx: Kind = .pushFragment, html: Redirect = .normal) -> Self {
        let next = switch req.query["next"] ?? "/" {
        case let n where n.starts(with: "/"): n
        case let n: "/\(n)"
        }

        return .init(to: next, htmx: htmx, html: html)
    }

    public static func auto(to location: String, from req: Request, key: String = "next", htmx: Kind = .pushFragment, html: Redirect = .normal) -> Self {
        let query = if let q = req.url.query { "?\(q)" } else { "" }
        let next = "\(location)?\(key)=\(req.url.path)\(query)"

        return .init(to: next, htmx: htmx, html: html)
    }
}