public actor HXResponseConfiguration: Sendable {
    public var headers: HXResponseHeaders

    public init() {
        headers = HXResponseHeaders()
    }
	
	public func setReswap(_ reswap: HXReswapHeader?) {
		self.headers.reswap = reswap
	}
	
	public func setRetarget(_ retarget: HXRetargetHeader?) {
		self.headers.retarget = retarget
	}
	
	public func setlocation(_ location: HXLocationHeader?) {
		self.headers.location = location
	}
	
	public func setPushUrl(_ pushUrl: HXPushUrlHeader?) {
		self.headers.pushUrl = pushUrl
	}
	
	public func setRedirect(_ redirect: HXRedirectHeader?) {
		self.headers.redirect = redirect
	}
	
	public func setRefresh(_ refresh: HXRefreshHeader?) {
		self.headers.refresh = refresh
	}
	
	public func setReplaceUrl(_ replaceUrl: HXReplaceUrlHeader?) {
		self.headers.replaceUrl = replaceUrl
	}
	
	public func setReselect(_ reselect: HXReselectHeader?) {
		self.headers.reselect = reselect
	}
	
	public func setTrigger(_ trigger: HXTriggerHeader?) {
		self.headers.trigger = trigger
	}
	
	public func setTriggerAfterSettle(_ triggerAfterSettle: HXTriggerAfterSettleHeader?) {
		self.headers.triggerAfterSettle = triggerAfterSettle
	}
	
	public func settTriggerAfterSwap(_ triggerAfterSwap: HXTriggerAfterSwapHeader?) {
		self.headers.triggerAfterSwap = triggerAfterSwap
	}
}
