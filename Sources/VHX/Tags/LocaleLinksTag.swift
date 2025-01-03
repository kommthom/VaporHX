//
//  LocaleLinksTag.swift
//  VHX
//
//  Created by Thomas Benninghaus on 23.12.24.
//

import Vapor
import Leaf

public final class LocaleLinksTag: UnsafeUnescapedLeafTag {
	public init() {}
	public func render(_ ctx: LeafContext) throws -> LeafData {
		guard let lingo = ctx.application?.localizations
		else {
			throw Abort(.internalServerError, reason: "Unable to get Lingo instance")
		}
		let locale = ctx.request?.language.prefered ?? lingo.defaultLocale
		
		guard ctx.parameters.count == 2,
			  let prefix = ctx.parameters[0].string,
			  let suffix = ctx.parameters[1].string
		else {
			throw Abort(.internalServerError, reason: "Wrong parameters count")
		}
		
		let canonical = "<link rel=\"canonical\" href=\"\(prefix)\(locale)\(suffix)\" />\n"
		
		let alternates = try lingo.dataSource.availableLocales().map { alternate in
			"<link rel=\"alternate\" hreflang=\"\(alternate)\" href=\"\(prefix)\(alternate)\(suffix)\" />\n"
		}
		
		return LeafData.string(canonical + alternates.joined())
	}
}
