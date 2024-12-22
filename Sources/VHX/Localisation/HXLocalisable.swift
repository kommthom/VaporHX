public protocol HXLocalisable: Sendable {
    func localise(text: String) -> String
}

public struct EnLocalizable: HXLocalisable {
	public func localise(text: String) -> String {
		text + " (En)"
	}
	
	public init () {}
}

public struct DeLocalizable: HXLocalisable {
	public func localise(text: String) -> String {
		text + " (De)"
	}
	
	public init () {}
}
