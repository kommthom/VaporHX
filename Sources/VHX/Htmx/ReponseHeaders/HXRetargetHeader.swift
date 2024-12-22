import Vapor

public struct HXRetargetHeader: HXResponseHeaderAddable, Sendable {
    public let value: String

    public func serialise() -> String {
        value
    }

    public func add(to resp: Response) {
        if !value.isEmpty {
            resp.headers.replaceOrAdd(name: "HX-Retarget", value: serialise())
        }
    }
}

public extension HXRetargetHeader {
    init(_ value: String) {
        self.value = value
    }
}
