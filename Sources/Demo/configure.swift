import LeafKit
import Vapor
import VHX

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder

    let pathToPublic = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent("Public").relativePath
    app.middleware.use(FileMiddleware(publicDirectory: pathToPublic))

    let pathToViews = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent("Views").relativePath
    app.leaf.sources = LeafSources.singleSource(
        NIOLeafFiles(fileio: app.fileio,
                     limits: .default,
                     sandboxDirectory: pathToViews,
                     viewDirectory: pathToViews))

    app.views.use(.leaf)

    let hxConfig = HtmxConfiguration.basic()
    try configureHtmx(app, configuration: hxConfig)
	let localizationConfiguration = LingoConfiguration.basic()
	try configureLocalization(app,
							  directory: URL(fileURLWithPath: #filePath).deletingLastPathComponent().relativePath,
							  configuration: localizationConfiguration)

    // register routes
    try routes(app)
}
