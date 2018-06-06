//
//  ViewController.swift
//  JXWeChatFloatView
//
//  Created by jiaxin on 2018/6/1.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let naviBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        naviBar.backgroundColor = UIColor.black
        self.view.addSubview(naviBar)

        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 44)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.text = "主页"
        naviBar.addSubview(titleLabel)

        self.view.backgroundColor = UIColor.white
    }

    @IBAction func pushVC(_ sender: UIButton) {
        let vc = TestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



