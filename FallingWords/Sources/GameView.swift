//
//  GameView.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit

class GameView : UIView {
    
    private lazy var fallingLabel : UILabel = {
        let fallingLabel = UILabel()
        fallingLabel.font = UIFont.systemFontOfSize(24)
        fallingLabel.textColor = UIColor.blackColor()
        return fallingLabel
    }()

    // MARK : View Methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        var perspectiveTransform = CATransform3DIdentity
        perspectiveTransform.m34 = 1 / -900
        self.layer.sublayerTransform = perspectiveTransform

        self.addSubview(fallingLabel)
        self.setDefaultConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setDefaultConstraints() {
        fallingLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp_centerX)
        }
    }

    func blinkWithColor(color: UIColor) {
        self.layer.addAnimation(blinkAnimationWithColor(color, andDuration: 0.3), forKey: "blink")
    }

    func startFallingLabelAnimationWithDuration(duration: Double) {
        fallingLabel.hidden = false
        fallingLabel.layer.addAnimation(trembleRepeatedAnimationGroupOfDuration(duration), forKey: "fall")
        fallingLabel.layer.addAnimation(translateAnimationFromTopToBottomOfViewOfDuration(duration), forKey: "shakeIt")
    }

    func stopFallingLabelAnimation() {
        fallingLabel.layer.removeAllAnimations()
        fallingLabel.hidden = true
    }

    func setFallingLabelText(text: String) {
        fallingLabel.text = text
        fallingLabel.sizeToFit()
    }

    // MARK: Helpers

    private func blinkAnimationWithColor(color: UIColor, andDuration duration: Double) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "backgroundColor")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.values = [UIColor.whiteColor().CGColor,color.CGColor,UIColor.whiteColor().CGColor]
        animation.duration = duration
        return animation
    }

    private func translateXRepeatableAnimationOfDistance(distance: Int) -> CAKeyframeAnimation {
        let translationX = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translationX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        translationX.values = [-distance, distance, -distance]
        return translationX
    }
    private func rotateYRepeatableAnimationOfDistance(distance: Int) -> CAKeyframeAnimation {
        let rotationY = CAKeyframeAnimation(keyPath: "transform.rotation.y");
        rotationY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        rotationY.values = [-distance, distance, -distance].map {
            self.toRadian($0)
        }
        return rotationY
    }

    private func translateAnimationFromTopToBottomOfViewOfDuration(duration: Double) -> CAKeyframeAnimation {
        let translationY = CAKeyframeAnimation(keyPath: "transform.translation.y");
        translationY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        translationY.values = [self.frame.origin.y - fallingLabel.frame.size.height, self.frame.origin.y + self.frame.size.height]
        translationY.duration = duration
        return translationY
    }

    private func trembleRepeatedAnimationGroupOfDuration(duration: Double) -> CAAnimationGroup {
        let trembleGroup: CAAnimationGroup = CAAnimationGroup()
        trembleGroup.animations = [
            translateXRepeatableAnimationOfDistance(Int(UI.Unit)),
            rotateYRepeatableAnimationOfDistance(Int(UI.Unit*5))
        ]
        trembleGroup.duration = 1
        trembleGroup.repeatCount = Float.infinity
        trembleGroup.repeatDuration = duration
        return trembleGroup
    }

    private func toRadian(value: Int) -> CGFloat {
        return CGFloat(Double(value) / 180.0 * M_PI)
    }
}