//
//  UIColor+Extension.swift
//  NewsApp
//
//  Created by Miran Mendelski on 13.04.2024..
//

import UIKit


extension UIColor {
    
    static let darkGray2 = rgb(24,24,24)
    static let darkInput = rgb(32, 31, 31)
    static let darkStroke = rgb(75, 75, 75)
    static let grayText = rgb(196,196,196)
    static let darkRed = rgb(139,0,0)
}


fileprivate extension UIColor {
    
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}
