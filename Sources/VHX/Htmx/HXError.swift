import Vapor

public struct HXError: Error {
    public let abort: Abort
    public let handler: @Sendable (_ req: Request, _ abort: Abort, _ htmxPreferred: Bool) async throws -> Response

    public init(abort: Abort, handler: @escaping @Sendable (_: Request, _: Abort, _: Bool) async throws -> Response) {
        self.abort = abort
        self.handler = handler
    }
}
