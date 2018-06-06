//
//  TestViewController.swift
//  JXWeChatFloatView
//
//  Created by jiaxin on 2018/6/1.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    var isNeedCustomTransition = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let red = CGFloat((arc4random()%255))/255
        let green = CGFloat((arc4random()%255))/255
        let blue = CGFloat((arc4random()%255))/255
        self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)

        let naviBarRed = CGFloat((arc4random()%255))/255
        let naviBarGreen = CGFloat((arc4random()%255))/255
        let naviBarBlue = CGFloat((arc4random()%255))/255
        let naviBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        naviBar.backgroundColor = UIColor(red: naviBarRed, green: naviBarGreen, blue: naviBarBlue, alpha: 1)
        self.view.addSubview(naviBar)

        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 44)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.text = "文章详情"
        naviBar.addSubview(titleLabel)

        let back = UIButton(type: .system)
        back.setTitle("返回", for: .normal)
        back.frame = CGRect(x: 20, y: 20, width: 44, height: 44)
        back.addTarget(self, action: #selector(backVC), for: .touchUpInside)
        naviBar.addSubview(back)

    }

    @objc func backVC() {
        self.navigationController?.popViewController(animated: true)
    }

}
