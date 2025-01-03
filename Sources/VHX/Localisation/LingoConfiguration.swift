//
//  LingoConfiguration.swift
//  VHX
//
//  Created by Thomas Benninghaus on 23.12.24.
//

import Vapor

public struct LingoConfiguration {
	let defaultLocale, localizationsDir: String
	
	public init(defaultLocale: String, localizationsDir: String = "Localizations") {
		self.defaultLocale = defaultLocale
		self.localizationsDir = localizationsDir
	}
	
	public static func basic() -> Self {
		return .init(defaultLocale: Locale.current.language.languageCode?.identifier ?? "en")
	}
}
