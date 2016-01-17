//
//  WordView.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 17/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit

class WordView : UIView {

    private lazy var wordLabel : UILabel = {
        let wordLabel = UILabel()
        wordLabel.font = UIFont.systemFontOfSize(18)
        wordLabel.textColor = UIColor.blackColor()
        return wordLabel
    }()

    // MARK : View Methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.addSubview(wordLabel)
        self.setDefaultConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setDefaultConstraints() {
        wordLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.centerX.equalTo(self.snp_centerX)
        }
    }

    func updateWordLabelWithString(string: String) {
        self.wordLabel.text = string
        self.wordLabel.sizeToFit()
    }
}
