import Vapor

struct CascadingSelectController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let select = routes.grouped("select", "models")
		
		select.get { req async throws in
			// Extract the Make from the URL or default to Audi if no query param is present
			let query = extractQuery(req: req)?.make ?? "Audi"
			req.logger.info("Query: `\(query)`")
			let makers = filterMakers()
			let models = filterModels(maker: query)
			let configurations = filterConfigurations(model: models[0])
			// Switch over the prefered request headers
			switch req.htmx.prefers {
				case .html:
					// The entire page is being requested
					return try await req.htmx.render("CascadingSelect/cascading-select", ["makers": makers, "models": models, "configurations": configurations])
				case .htmx:
					// Just a fragment with the related models is being requested
					return try await req.htmx.render("CascadingSelect/cascading-select-options", ["models": models, "configurations": configurations])
				case .api:
					// The JSON api is being requested
					return try! await CascadingSelect.DTO(makers: makers, models: models, configurations: configurations).encodeResponse(for: req)
			}
		}
		
		select.post("configurations") { req async throws in
			var configurations: [String] = .init()
			if let query = try? req.content.decode(CascadingSelect.QueryModel.self), !query.model.isEmpty {
				req.logger.info("Query: `\(query.model)`")
				configurations = filterConfigurations(model: query.model)
			} else {
				req.logger.warning("No Query")
			}
			return try await req.htmx.render("CascadingSelect/cascading-select-configurations", ["configurations": configurations])
		}
	}
}

private func extractQuery(req: Request) -> CascadingSelect.QueryMake? {
	try? req.query.decode(CascadingSelect.QueryMake.self)
}

private func filterMakers() -> [String] {
	CascadingSelect.default.makes.map { $0.maker }.uniqued(on: { $0 } )
}

private func filterModels(maker: String) -> [String] {
	CascadingSelect.default.makes.filter { $0.maker == maker }.map { $0.model } .uniqued(on: { $0 } )
}

private func filterConfigurations(model: String) -> [String] {
	CascadingSelect.default.makes.filter { $0.model == model }.map { $0.configuration } .uniqued(on: { $0 } )
}

struct CascadingSelect: Content, Sendable {
	/// The URL encoded query that our HTMX select view generates
	struct QueryMake: Content, Sendable {
		let make: String
	}
	
	struct QueryModel: Content, Sendable {
		let model: String
	}
	
	struct DTO: Content, Sendable {
		let makers: [String]
		let models: [String]
		let configurations: [String]
	}
	
	/// A helper struct for sending data into our Leaf template
	struct Make: Content, Hashable, Sendable {
		let maker: String
		let model: String
		let configuration: String
	}
	
	var makes: [Make]
	
	/// A collection of Makes and Models of cars to choose from
	static let `default`: CascadingSelect = .init(makes: [
		.init(maker: "Audi", model: "a1", configuration: "b1"),
		.init(maker: "Audi", model: "a1", configuration: "b2"),
		.init(maker: "Audi", model: "a1", configuration: "b3"),
		.init(maker: "Audi", model: "a2", configuration: "b4"),
		.init(maker: "Audi", model: "a2", configuration: "b5"),
		.init(maker: "Audi", model: "a2", configuration: "b6"),
		.init(maker: "Audi", model: "a6", configuration: "a7"),
		.init(maker: "Audi", model: "a6", configuration: "b8"),
		.init(maker: "Audi", model: "a6", configuration: "b9"),
		.init(maker: "BMW", model: "325i", configuration: "c1"),
		.init(maker: "BMW", model: "325i", configuration: "c2"),
		.init(maker: "BMW", model: "325i", configuration: "c3"),
		.init(maker: "BMW", model: "325ix", configuration: "c4"),
		.init(maker: "BMW", model: "325ix", configuration: "c5"),
		.init(maker: "BMW", model: "325ix", configuration: "c6"),
		.init(maker: "BMW", model: "x5", configuration: "c7"),
		.init(maker: "BMW", model: "x5", configuration: "c8"),
		.init(maker: "BMW", model: "x5", configuration: "c9"),
		.init(maker: "Toyota", model: "landcruiser", configuration: "d1"),
		.init(maker: "Toyota", model: "landcruiser", configuration: "d2"),
		.init(maker: "Toyota", model: "landcruiser", configuration: "d3"),
		.init(maker: "Toyota", model: "tacoma", configuration: "d4"),
		.init(maker: "Toyota", model: "tacoma", configuration: "d5"),
		.init(maker: "Toyota", model: "tacoma", configuration: "d6"),
		.init(maker: "Toyota", model: "yaris", configuration: "d7"),
		.init(maker: "Toyota", model: "yaris", configuration: "d8"),
		.init(maker: "Toyota", model: "yaris", configuration: "d9")
	])
}
