//
//  JXArticleFloatCollectView.swift
//  JXWeChatFloatView
//
//  Created by jiaxin on 2018/6/4.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class JXArticleFloatCollectView: UIView {
    let bgLayer = CAShapeLayer()
    var viewSize: CGSize {
        return self.bounds.size
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
        
        bgLayer.fillColor = UIColor.red.cgColor
        self.updateBGLayerPath(isSmall: true)
        bgLayer.frame = self.bounds
        self.layer.addSublayer(bgLayer)
    }

    func updateBGLayerPath(isSmall: Bool) {
        var ratio:CGFloat = 1
        if !isSmall {
            ratio = 1.3
        }
        let path = UIBezierPath()
        path.move(to: CGPoint(x: viewSize.width, y: (1 - ratio)*viewSize.height))
        path.addLine(to: CGPoint(x: viewSize.width, y: viewSize.height))
        path.addLine(to: CGPoint(x: (1 - ratio)*viewSize.width, y: viewSize.height))
        path.addArc(withCenter: CGPoint(x: viewSize.width, y: viewSize.height), radius: viewSize.width*ratio, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi*3/2), clockwise: true)
        path.close()
        bgLayer.path = path.cgPath
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bgLayer.path!.contains(point)
    }


}
