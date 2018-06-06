//
//  JXArticleFloatWindow.swift
//  JXWeChatFloatView
//
//  Created by jiaxin on 2018/6/1.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

enum JXArticleFloatWindowStatus {
    case windowHideen
    case roundEntryViewShowed
    case roundEntryViewHideen
}

class JXArticleFloatWindow: UIWindow {
    static let shared = JXArticleFloatWindow()
    var status: JXArticleFloatWindowStatus = .windowHideen
    weak var naviController: UINavigationController?
    let screenSize = UIScreen.main.bounds.size
    let collectViewWidth: CGFloat = 150
    var collectionViewOriginalFrame: CGRect {
        return CGRect(x: screenSize.width, y: UIScreen.main.bounds.size.height, width: collectViewWidth, height: collectViewWidth)
    }
    var collectionViewDisplayFrame: CGRect {
        return CGRect(x: screenSize.width - collectViewWidth, y: screenSize.height - collectViewWidth, width: collectViewWidth, height: collectViewWidth)
    }
    let roundEntryViewWidth: CGFloat = 100
    let roundEntryViewMargin: CGFloat = 20
    var collectView: JXArticleFloatCollectView!
    var roundEntryView: JXArticleFloatRoundEntryView!

    init() {
        super.init(frame: UIScreen.main.bounds)

        self.windowLevel = UIWindowLevelStatusBar - 1
        self.isHidden = true

        self.backgroundColor = UIColor.clear

        collectView = JXArticleFloatCollectView(frame: collectionViewOriginalFrame)
        self.addSubview(collectView)

        roundEntryView = JXArticleFloatRoundEntryView(frame: CGRect(x: screenSize.width - roundEntryViewMargin - roundEntryViewWidth, y: (screenSize.height - roundEntryViewWidth)/2, width: roundEntryViewWidth, height: roundEntryViewWidth))
        roundEntryView.layer.cornerRadius = roundEntryViewWidth/2
        roundEntryView.backgroundColor = .blue
        roundEntryView.isHidden = true
        roundEntryView.clickedCallback = {[weak self] in
            self?.pushVC()
        }
        self.addSubview(roundEntryView)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(processRoundEntryView(gesture:)))
        roundEntryView.addGestureRecognizer(pan)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func handleNavigationTransition(gesture: UIScreenEdgePanGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        if status == .windowHideen {
            if gesture.state == .began {
                self.isHidden = false
            }else if gesture.state == .changed {
                var percent = point.x/screenSize.width
                //20%开始出现，50%完全展示
                percent -= 0.2
                percent *= 10/3
                percent = min(1, max(0, percent))
                var frame = collectView.frame
                frame.origin.x = self.interpolate(from: collectionViewDisplayFrame.origin.x, to: collectionViewOriginalFrame.origin.x, percent: 1 - percent)
                frame.origin.y = self.interpolate(from: collectionViewDisplayFrame.origin.y, to: collectionViewOriginalFrame.origin.y, percent: 1 - percent)
                collectView.frame = frame

                var isCollectViewInside = false
                let collectViewPoint = self.convert(point, to: collectView)
                if collectView.point(inside: collectViewPoint, with: nil) == true {
                    isCollectViewInside = true
                }
                collectView.updateBGLayerPath(isSmall: !isCollectViewInside)
            }else if gesture.state == .ended {

                if collectView.frame.contains(point) {
                    roundEntryView.isHidden = false
                    status = .roundEntryViewShowed
                    self.hideCollectView(completion: nil)
                }else {
                    self.hideCollectView {
                        self.isHidden = true
                    }
                }

            }else if gesture.state == .cancelled {
                self.hideCollectView {
                    self.isHidden = true
                }
            }
        }else if status == .roundEntryViewShowed {
            //不做任何处理
        }else if status == .roundEntryViewHideen {
            if gesture.state == .began {

            }else if gesture.state == .changed {
                let percent = point.x/screenSize.width
                roundEntryView.alpha = percent
            }else if gesture.state == .ended {
                roundEntryView.alpha = 1
                status = .roundEntryViewShowed
            }else if gesture.state == .cancelled {
                roundEntryView.alpha = 0
            }
        }
    }

    //MARK: - Event
    @objc func processRoundEntryView(gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: self)
        if gesture.state == .began {
            self.displayCollectView()
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                self.roundEntryView.center = point
            }) { (finished) in

            }
        }else if gesture.state == .changed {
            roundEntryView.center = point
            var isCollectViewInside = false
            let collectViewPoint = self.convert(point, to: collectView)
            if collectView.point(inside: collectViewPoint, with: nil) == true {
                isCollectViewInside = true
            }
            collectView.updateBGLayerPath(isSmall: !isCollectViewInside)
        }else if gesture.state == .ended || gesture.state == .cancelled {
            let collectViewPoint = self.convert(point, to: collectView)
            if collectView.point(inside: collectViewPoint, with: nil) == true {
                self.hideCollectView(completion: nil)
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                    self.roundEntryView.alpha = 0
                }) { (finished) in
                    self.roundEntryView.isHidden = true
                    self.roundEntryView.alpha = 1
                    self.isHidden = true
                    self.status = .windowHideen
                }
            }else {
                var frame = roundEntryView.frame
                if point.x > screenSize.width/2 {
                    frame.origin.x = screenSize.width - roundEntryViewMargin - roundEntryViewWidth
                }else {
                    frame.origin.x = roundEntryViewMargin
                }
                self.hideCollectView(completion: nil)
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.roundEntryView.frame = frame
                }) { (finished) in

                }
            }
        }
    }

    func pushVC() {
        let vc = TestViewController()
        vc.isNeedCustomTransition = true
        self.naviController?.pushViewController(vc, animated: true)
    }

    func displayCollectView() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.collectView.frame = self.collectionViewDisplayFrame
        }) { (finished) in

        }
    }

    func hideCollectView(completion: (()->())?) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.collectView.frame = self.collectionViewOriginalFrame
        }) { (finished) in
            completion?()
        }
    }

    //MARK: - Private
    private func interpolate(from: CGFloat, to: CGFloat, percent: CGFloat) -> CGFloat {
        return from + (to - from)*percent
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let roundEntryViewPoint = self.convert(point, to: roundEntryView)
        if roundEntryView.point(inside: roundEntryViewPoint, with: event) == true {
            return true
        }
        let collectViewPoint = self.convert(point, to: collectView)
        if collectView.point(inside: collectViewPoint, with: event) == true {
            return true
        }
        return false
    }
}
