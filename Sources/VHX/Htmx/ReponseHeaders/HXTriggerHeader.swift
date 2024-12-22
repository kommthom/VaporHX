import Vapor

public typealias SendableEncodable = Encodable & Sendable

public enum HXTriggerEvent: Sendable {
    case basic([String])
    case custom([HXTriggerEventKind])
}

public enum HXTriggerEventKind: Sendable {
    case message(name: String, value: String)
    case object(name: String, value: any SendableEncodable)
}

public struct HXTriggerHeader: HXResponseHeaderAddable, Sendable {
    public let values: HXTriggerEvent

    public func serialise() -> String {
        values.serialise()
    }

    public func add(to resp: Response) {
        let serialised = serialise()

        if !serialised.isEmpty {
            resp.headers.replaceOrAdd(name: "HX-Trigger", value: serialised)
        }
    }
}

public struct HXTriggerAfterSettleHeader: HXResponseHeaderAddable, Sendable {
    public let value: HXTriggerEvent

    public func serialise() -> String {
        value.serialise()
    }

    public func add(to resp: Response) {
        let serialised = serialise()

        if !serialised.isEmpty {
            resp.headers.replaceOrAdd(name: "HX-Trigger-After-Settle", value: serialised)
        }
    }
}

public struct HXTriggerAfterSwapHeader: HXResponseHeaderAddable, Sendable {
    public let value: HXTriggerEvent

    public func serialise() -> String {
        value.serialise()
    }

    public func add(to resp: Response) {
        let serialised = serialise()

        if !serialised.isEmpty {
            resp.headers.replaceOrAdd(name: "HX-Trigger-After-Swap", value: serialised)
        }
    }
}

public extension [HXTriggerEventKind] {
    // The solution taken from:
    // https://forums.swift.org/t/how-to-encode-objects-of-unknown-type/12253/2
    private struct AnyEncodable: Encodable, Sendable {
		private let _encode: @Sendable (Encoder) throws -> Void
        public init(_ wrapped: some SendableEncodable) {
            _encode = wrapped.encode
        }

        @Sendable func encode(to encoder: Encoder) throws {
            try _encode(encoder)
        }
    }

    func serialise() -> String {
        var data: [String: AnyEncodable] = [:]

        for i in self {
            switch i {
            case let .message(name: name, value: value):
                data[name] = AnyEncodable(value)
            case let .object(name: name, value: value):
                data[name] = AnyEncodable(value)
            }
        }

        guard let values = try? String(data: JSONEncoder().encode(data), encoding: .utf8) else {
            return ""
        }

        return values
    }
}

public extension HXTriggerEvent {
    func serialise() -> String {
        switch self {
        case let .basic(events):
            events.joined(separator: ", ")
        case let .custom(events):
            events.serialise()
        }
    }
}

public extension HXTriggerHeader {
    init(_ values: String...) {
        self.values = .basic(values)
    }

    init(_ values: HXTriggerEventKind...) {
        self.values = .custom(values)
    }
}
