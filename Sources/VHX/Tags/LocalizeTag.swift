//
//  LocalizeTag.swift
//  VHX
//
//  Created by Thomas Benninghaus on 23.12.24.
//

import Vapor
import Leaf

public enum LocalizeTagError: Error {
	case invalidFormatParameter
	case wrongNumberOfParameters
}

public final class LocalizeTag: LeafTag {
	public init() {}
	public func render(_ ctx: LeafContext) throws -> LeafData {
		let parametersCount = ctx.parameters.count
		if parametersCount == 0 {
			throw LocalizeTagError.wrongNumberOfParameters
		}
		guard let text: String = ctx.parameters.first?.string else {
			throw LocalizeTagError.invalidFormatParameter
		}

		let code: String?

		if parametersCount % 2 == 1 {
			guard let c = ctx.parameters.last?.string else {
				throw LocalizeTagError.invalidFormatParameter
			}
			code = c
		} else {
			code = nil
		}

		let localized = if let req = ctx.request {
			req.language.localize(text: text, interpolations: try getInterpolations(parameters: ctx.parameters, parameterCount: parametersCount), for: code)
		} else {
			text
		}
		
		return LeafData.string(localized)
	}
	
	private func getInterpolations(parameters: [LeafData], parameterCount: Int) throws-> [String: Any]? {
		if parameterCount == 3 {
			guard let body = parameters[1].string, body != "nil" else { return nil }
			guard let bodyData = body.data(using: .utf8),
				  let interpolations = try? JSONSerialization.jsonObject(with: bodyData, options: []) as? [String: AnyObject]
			else {
				throw LocalizeTagError.invalidFormatParameter
			}
			return interpolations
		} else {
			var interpolations: [String: String] = [:]
			try stride(from: 1, to: parameterCount, by: 2).forEach { i in
				guard let interpolationKey = parameters[i].string,
					  let interpolationValue = parameters[i + 1].string else {
					throw LocalizeTagError.invalidFormatParameter
				}
				interpolations[interpolationKey] = interpolationValue
			}
			return interpolations
		}
	}
}
