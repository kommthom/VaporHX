import LeafKit
import Vapor

public protocol HXLeafSource: LeafSource, Sendable {
    var pagePrefix: String { get }
}

public typealias PageTemplateBuilder = @Sendable (_ name: String) -> String

public struct HXBasicLeafSource: HXLeafSource, Sendable {
    public let pagePrefix: String
    public let pageTemplate: PageTemplateBuilder

    public enum HtmxPageLeafSourceError: Error {
        case illegalFormat
    }

    public func file(template: String, escape _: Bool, on eventLoop: EventLoop) throws -> EventLoopFuture<ByteBuffer> {
        guard template.starts(with: "\(pagePrefix)/") else {
            throw HtmxPageLeafSourceError.illegalFormat
        }

        let remainder = template.dropFirst(7)

        guard remainder.distance(from: remainder.startIndex, to: template.endIndex) > 0 else {
            throw HtmxPageLeafSourceError.illegalFormat
        }

        let result = pageTemplate(String(remainder))

        let buffer = ByteBuffer(string: result)

        return eventLoop.makeSucceededFuture(buffer)
    }
}

@Sendable public func hxPageLeafSource(prefix: String = "--page", template: PageTemplateBuilder?) -> HXLeafSource {
    if let template {
        return HXBasicLeafSource(pagePrefix: prefix, pageTemplate: template)
    } else {
        @Sendable func template(_ name: String) -> String {
            """
            #extend("\(name)")
            """
        }
        return HXBasicLeafSource(
			pagePrefix: prefix,
			pageTemplate: template
		)
    }
}

public func hxBasicPageLeafSource(prefix: String = "--page", baseTemplate: String = "index-base", slotName: String = "body") -> HXLeafSource {
    let template = HXBasicLeafTemplate.prepareBasicTemplateBuilder(defaultBaseTemplate: baseTemplate, defaultSlotName: slotName)

    return HXBasicLeafSource(pagePrefix: prefix, pageTemplate: template)
}
