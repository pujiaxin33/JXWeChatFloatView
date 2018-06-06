//
//  BaseNavigationViewController.swift
//  JXWeChatFloatView
//
//  Created by jiaxin on 2018/6/1.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        self.interactivePopGestureRecognizer?.delaysTouchesBegan = true
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = true

        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleNavigationTransition(gesture:)))
        gesture.edges = .left
        self.view.addGestureRecognizer(gesture)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    @objc func handleNavigationTransition(gesture: UIScreenEdgePanGestureRecognizer) {
        JXArticleFloatWindow.shared.naviController = self
        JXArticleFloatWindow.shared.handleNavigationTransition(gesture: gesture)
    }
    
}

//MARK: - UIGestureRecognizerDelegate
extension BaseNavigationViewController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count <= 1 {
            return false
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension BaseNavigationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var isCustomTransition = false
        if operation == .push {
            if let testVC = toVC as? TestViewController {
                isCustomTransition = testVC.isNeedCustomTransition
            }
        }else if operation == .pop {
            if let testVC = fromVC as? TestViewController {
                isCustomTransition = testVC.isNeedCustomTransition
            }
        }
        if isCustomTransition {
            return JXArticleFloatRoundEntryAnimator(operation: operation, sourceCenter: JXArticleFloatWindow.shared.roundEntryView.center)
        }else {
            return nil
        }
    }
}
