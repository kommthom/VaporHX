//
//  LocaleTag.swift
//  VHX
//
//  Created by Thomas Benninghaus on 23.12.24.
//

import Vapor
import Leaf

public final class LocaleTag: LeafTag {
	public init() {}
	public func render(_ ctx: LeafContext) throws -> LeafData {
		return LeafData.string(ctx.request?.language.prefered ?? ctx.application?.localizations.defaultLocale ?? "en")
	}
}
