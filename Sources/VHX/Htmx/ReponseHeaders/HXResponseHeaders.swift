import Vapor

public struct HXResponseHeaders: HXResponseHeaderAddable, Sendable {
    public var location: HXLocationHeader?
    public var pushUrl: HXPushUrlHeader?
    public var redirect: HXRedirectHeader?
    public var refresh: HXRefreshHeader?
    public var replaceUrl: HXReplaceUrlHeader?
    public var reselect: HXReselectHeader?
    public var reswap: HXReswapHeader?
    public var retarget: HXRetargetHeader?
    public var trigger: HXTriggerHeader?
    public var triggerAfterSettle: HXTriggerAfterSettleHeader?
    public var triggerAfterSwap: HXTriggerAfterSwapHeader?

    public func add(to resp: Response) {
        location.map { $0.add(to: resp) }
        pushUrl.map { $0.add(to: resp) }
        redirect.map { $0.add(to: resp) }
        refresh.map { $0.add(to: resp) }
        replaceUrl.map { $0.add(to: resp) }
        reselect.map { $0.add(to: resp) }
        reswap.map { $0.add(to: resp) }
        retarget.map { $0.add(to: resp) }
        trigger.map { $0.add(to: resp) }
        triggerAfterSettle.map { $0.add(to: resp) }
        triggerAfterSwap.map { $0.add(to: resp) }
    }

    mutating func merge(with headers: HXResponseHeaders) {
        location = location ?? headers.location
        pushUrl = pushUrl ?? headers.pushUrl
        redirect = redirect ?? headers.redirect
        refresh = refresh ?? headers.refresh
        replaceUrl = replaceUrl ?? headers.replaceUrl
        reselect = reselect ?? headers.reselect
        reswap = reswap ?? headers.reswap
        retarget = retarget ?? headers.retarget
        trigger = trigger ?? headers.trigger
        triggerAfterSettle = triggerAfterSettle ?? headers.triggerAfterSettle
        triggerAfterSwap = triggerAfterSwap ?? headers.triggerAfterSwap
    }

    public init(location: HXLocationHeader? = nil, pushUrl: HXPushUrlHeader? = nil, redirect: HXRedirectHeader? = nil, refresh: HXRefreshHeader? = nil, replaceUrl: HXReplaceUrlHeader? = nil, reselect: HXReselectHeader? = nil, reswap: HXReswapHeader? = nil, retarget: HXRetargetHeader? = nil, trigger: HXTriggerHeader? = nil, triggerAfterSettle: HXTriggerAfterSettleHeader? = nil, triggerAfterSwap: HXTriggerAfterSwapHeader? = nil) {
        self.location = location
        self.pushUrl = pushUrl
        self.redirect = redirect
        self.refresh = refresh
        self.replaceUrl = replaceUrl
        self.reselect = reselect
        self.reswap = reswap
        self.retarget = retarget
        self.trigger = trigger
        self.triggerAfterSettle = triggerAfterSettle
        self.triggerAfterSwap = triggerAfterSwap
    }
}
