
import UIKit

import ObjectiveC.runtime

private var contextKey: UInt8 = 0

extension CADisplayLink {
    var context: FallAnimationContext? {
        get { objc_getAssociatedObject(self, &contextKey) as? FallAnimationContext }
        set { objc_setAssociatedObject(self, &contextKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
