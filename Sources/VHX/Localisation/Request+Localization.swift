import Vapor

public extension Request {
    var language: HXRequestLocalization {
        .init(req: self)
    }
}
