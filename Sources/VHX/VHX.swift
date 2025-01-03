import Vapor
import Lingo

public func configureHtmx(_ app: Application, pageTemplate template: PageTemplateBuilder? = nil) throws {
    let config = if let template {
        HtmxConfiguration(pageTemplate: template)
    } else {
        HtmxConfiguration()
    }

    try configureHtmx(app, configuration: config)
}

public func configureHtmx(_ app: Application, configuration: HtmxConfiguration) throws {
    app.htmx = configuration
    app.middleware.use(HXErrorMiddleware())

    app.views.use(.leaf)
    // Saving currnet sources in case these are the default sources
    app.leaf.sources = app.leaf.sources

    try app.leaf.sources.register(source: "hx", using: app.htmx.pageSource, searchable: true)
}

public func configureLocalization(_ app: Application, directory: String?, configuration: LingoConfiguration?, textTag: String = "localize") throws {
    app.leaf.tags[textTag] = LocalizeTag()
	app.leaf.tags["locale"] = LocaleTag()
	app.leaf.tags["localeLinks"] = LocaleLinksTag()
	let directory = directory ?? app.directory.workingDirectory
	let workDir = directory.hasSuffix("/") ? directory : directory + "/"
	let rootPath = workDir + (configuration?.localizationsDir ?? "")
	let lingo = try Lingo(rootPath: rootPath, defaultLocale: (configuration?.defaultLocale ?? ""))
    app.localizations = lingo
}

public func staticRoute(template: String) -> (@Sendable (Request) async throws -> Response) {
    { (req: Request) async throws in
        try await req.htmx.render(template)
    }
}

public func staticRoute<T: HXTemplateable>(template: T.Type) -> (@Sendable (Request) async throws -> Response) where T.Context == EmptyContext {
    { (req: Request) async throws in
        try await req.htmx.render(template, .init())
    }
}
