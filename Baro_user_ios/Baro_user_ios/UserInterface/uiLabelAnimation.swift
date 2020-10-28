//
//  uiLabelAnimation.swift
//  Baro_user_ios
//
//  Created by yUsiL on 2020/10/27.
//

import UIKit
class uiLabelAnimation : UILabel {
    
    var duration = 0.0
    
    
    func animate(duration: CFTimeInterval = 0.07, stopRound: Int = 1) {
            self.duration = duration
            self.animate()
    }
    private func animate() {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.type = .push
        animation.subtype = .fromTop
        animation.delegate = self
        
        self.layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}

extension uiLabelAnimation : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if duration.isZero {
               self.layer.removeAllAnimations()
               return
       }
       self.animate()
   }
}
