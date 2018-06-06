//
//  JXArticleFloatRoundEntryAnimator.swift
//  JXWeChatFloatView
//
//  Created by jiaxin on 2018/6/5.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class JXArticleFloatRoundEntryAnimator: NSObject {
    var operation: UINavigationControllerOperation?
    var sourceCenter: CGPoint?

    init(operation: UINavigationControllerOperation, sourceCenter: CGPoint) {
        self.sourceCenter = sourceCenter
        self.operation = operation
        super.init()

    }
}

extension JXArticleFloatRoundEntryAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let mask = CAShapeLayer()
        let size: CGFloat = 100
        let sourceRect = CGRect(x: sourceCenter!.x - size/2, y: sourceCenter!.y - size/2, width: size, height: size)
        let sourcePath = UIBezierPath(roundedRect: sourceRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10))
        let screenPath = UIBezierPath(roundedRect: UIScreen.main.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 100, height: 100))

        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = self.transitionDuration(using: transitionContext)
        animation.delegate = self
        animation.isRemovedOnCompletion = true
        animation.setValue(transitionContext, forKey: "transitionContext")
        animation.setValue(mask, forKey: "mask")

        if operation == .push {
            JXArticleFloatWindow.shared.roundEntryView.alpha = 0
            JXArticleFloatWindow.shared.status = .roundEntryViewHideen

            mask.path = screenPath.cgPath
            let toView = transitionContext.view(forKey: .to)
            toView?.layer.mask = mask
            transitionContext.containerView.addSubview(toView!)

            animation.fromValue = sourcePath.cgPath
            animation.toValue = screenPath.cgPath
        }else {
            JXArticleFloatWindow.shared.roundEntryView.alpha = 1
            JXArticleFloatWindow.shared.status = .roundEntryViewShowed

            let fromView = transitionContext.view(forKey: .from)
            let toView = transitionContext.view(forKey: .to)
            transitionContext.containerView.insertSubview(toView!, at: 0)

            mask.path = sourcePath.cgPath
            fromView?.layer.mask = mask
            animation.fromValue = screenPath.cgPath
            animation.toValue = sourcePath.cgPath
        }

        mask.add(animation, forKey: "pathAnimation")
    }
}

extension JXArticleFloatRoundEntryAnimator: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let mask = anim.value(forKey: "mask") as! CAShapeLayer
        mask.removeFromSuperlayer()

        let transitionContext = anim.value(forKey: "transitionContext") as! UIViewControllerContextTransitioning
        transitionContext.completeTransition(flag)
    }
}
