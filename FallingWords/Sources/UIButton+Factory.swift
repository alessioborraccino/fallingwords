//
//  WordButton.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import UIKit

extension UIButton {

    class func mainGameButton() -> UIButton {
        let button = UIButton(type: .Custom)
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.mainGameColor(), forState: .Normal)
        return button
    }
}
