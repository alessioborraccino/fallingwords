//
//  HUDView.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit

class HUDView : UIView {

    private lazy var countdownLabel : UILabel = {
        let countdownLabel = UILabel()
        countdownLabel.font = UIFont.systemFontOfSize(18)
        countdownLabel.textColor = UIColor.blackColor()
        return countdownLabel
    }()

    private lazy var scoreLabel : UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.font = UIFont.systemFontOfSize(18)
        scoreLabel.textColor = UIColor.blackColor()
        return scoreLabel
    }()

    // MARK : View Methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.addSubview(countdownLabel)
        self.addSubview(scoreLabel)
        self.setDefaultConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDefaultConstraints() {
        countdownLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(self.snp_left).offset(UI.DefaultPadding)
        }

        scoreLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(self.snp_right).offset(-UI.DefaultPadding)
        }
    }

    func updateCountdownLabelWithString(string: String) {
        self.countdownLabel.text = string
        self.countdownLabel.sizeToFit()
    }

    func updateScoreLabelWithString(string: String) {
        self.scoreLabel.text = string
        self.scoreLabel.sizeToFit()
    }
}
