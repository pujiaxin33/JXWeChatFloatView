//
//  JXArticleFloatTabBarController.swift
//  JXWeChatFloatView
//
//  Created by jiaxin on 2018/6/6.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class JXArticleFloatTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }


}

extension JXArticleFloatTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        JXArticleFloatWindow.shared.naviController = viewController as? UINavigationController
    }
}
