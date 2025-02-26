
import UIKit

class FallAnimationContext {
    var collidedImageView: UIImageView
    var targetDistance: CGFloat
    var fallDistance: CGFloat = 0
    
    init(collidedImageView: UIImageView, targetDistance: CGFloat) {
        self.collidedImageView = collidedImageView
        self.targetDistance = targetDistance
    }
}
