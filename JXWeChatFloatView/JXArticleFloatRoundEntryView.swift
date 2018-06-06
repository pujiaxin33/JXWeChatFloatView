//
//  JXArticleFloatRoundEntryView.swift
//  JXWeChatFloatView
//
//  Created by jiaxin on 2018/6/4.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class JXArticleFloatRoundEntryView: UIView {
    var clickedCallback: (()->())?

    deinit {
        clickedCallback = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        self.addGestureRecognizer(tap)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTap(gesture: UITapGestureRecognizer) {
        clickedCallback?()
    }


}
