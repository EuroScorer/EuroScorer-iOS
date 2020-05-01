//
//  UIButton+BackgroundColor.swift
//  EuroScorer
//
//  Created by Sacha DSO on 19/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit

extension UIButton {

    public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let img = UIImage(color: color, size: CGSize(width: 1.0, height: 1.0))
        setBackgroundImage(img, for: state)
    }
}

extension UIImage {
    public convenience init(color: UIColor, size: CGSize) {
        var rect = CGRect.zero
        rect.size = size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.setFill()
        UIRectFill(rect)
        let uiImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let cgImage = uiImage?.cgImage {
            self.init(cgImage: cgImage)
        } else {
            self.init()
        }
    }
}
