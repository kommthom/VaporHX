import Vapor

public struct HXLocationHeader: HXResponseHeaderAddable, Sendable {
	public enum HXLocationType: Sendable {
        case simple(String)
        case custom(HXCustomLocation)
    }

    public struct HXCustomLocation: Encodable, Sendable {
        public let path: String
        public let target: String?
        public let source: String?
        public let event: String?
        public let handler: String?
        public let swap: HXReswapHeader?
        public let values: [String]?
        public let headers: [String: String]?
    }

    public let location: HXLocationType

    public func serialise() -> String {
        switch location {
        case let .simple(simple):
            return if simple.isEmpty {
                "/"
            } else {
                simple
            }
        case let .custom(custom):
            guard !custom.path.isEmpty else {
                return "/"
            }
            guard let values = try? String(data: JSONEncoder().encode(custom), encoding: .utf8) else {
                return "/"
            }
            return values
        }
    }

    public func add(to resp: Response) {
        let serialised = serialise()

        if !serialised.isEmpty {
            resp.headers.replaceOrAdd(name: "HX-Location", value: serialised)
        }
    }
}

public extension HXLocationHeader {
    init(_ path: String) {
        location = .simple(path)
    }

    init(_ path: String, target: String? = nil, source: String? = nil, event: String? = nil, handler: String? = nil, swap: HXReswapHeader? = nil, values: [String]? = nil, headers: [String: String]? = nil) {
        location = .custom(.init(path: path, target: target, source: source, event: event, handler: handler, swap: swap, values: values, headers: headers))
    }

    func set(target newTarget: String) -> Self {
        switch location {
        case let .simple(path):
            .init(path, target: newTarget)
        case let .custom(custom):
            .init(custom.path, target: newTarget, source: custom.source, event: custom.event, handler: custom.handler, swap: custom.swap, values: custom.values, headers: custom.headers)
        }
    }

    func set(source newSource: String?) -> Self {
        switch location {
        case let .simple(path):
            if let newSource {
                .init(path, source: newSource)
            } else {
                self
            }

        case let .custom(custom):
            .init(custom.path, target: custom.target, source: newSource, event: custom.event, handler: custom.handler, swap: custom.swap, values: custom.values, headers: custom.headers)
        }
    }

    func set(event newEvent: String?) -> Self {
        switch location {
        case let .simple(path):
            if let newEvent {
                .init(path, event: newEvent)
            } else {
                self
            }
        case let .custom(custom):
            .init(custom.path, target: custom.target, source: custom.source, event: newEvent, handler: custom.handler, swap: custom.swap, values: custom.values, headers: custom.headers)
        }
    }

    func set(handler newHandler: String?) -> Self {
        switch location {
        case let .simple(path):
            if let newHandler {
                .init(path, handler: newHandler)
            } else {
                self
            }
        case let .custom(custom):
            .init(custom.path, target: custom.target, source: custom.source, event: custom.event, handler: newHandler, swap: custom.swap, values: custom.values, headers: custom.headers)
        }
    }

    func set(swap newSwap: HXReswapHeader?) -> Self {
        switch location {
        case let .simple(path):
            if let newSwap {
                .init(path, swap: newSwap)
            } else {
                self
            }
        case let .custom(custom):
            .init(custom.path, target: custom.target, source: custom.source, event: custom.event, handler: custom.handler, swap: newSwap, values: custom.values, headers: custom.headers)
        }
    }

    func set(values newValues: [String]?) -> Self {
        switch location {
        case let .simple(path):
            if let newValues {
                .init(path, values: newValues)
            } else {
                self
            }
        case let .custom(custom):
            .init(custom.path, target: custom.target, source: custom.source, event: custom.event, handler: custom.handler, swap: custom.swap, values: newValues, headers: custom.headers)
        }
    }

    func set(headers newHeaders: [String: String]?) -> Self {
        switch location {
        case let .simple(path):
            if let newHeaders {
                .init(path, headers: newHeaders)
            } else {
                self
            }
        case let .custom(custom):
            .init(custom.path, target: custom.target, source: custom.source, event: custom.event, handler: custom.handler, swap: custom.swap, values: custom.values, headers: newHeaders)
        }
    }

    func makeSimple(_ path: String? = nil) -> Self {
        if let path {
            .init(path)
        } else {
            switch location {
            case .simple:
                self
            case let .custom(custom):
                .init(custom.path)
            }
        }
    }
}
