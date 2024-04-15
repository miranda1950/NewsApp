//
//  Fonts.swift
//  MobileBankingApp
//
//  Created by Miran Mendelski on 09.04.2024..
//

import UIKit

enum Font: String {
    
    case robotoRegular = "Roboto-Regular"
    case robotoBold = "Roboto-Bold"
    
    var name: String {
        return self.rawValue
    }
    
    func size(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
    
    static func regularRoboto(size: CGFloat) -> UIFont {
        return Font.robotoRegular.size(size)
    }
    
    static func boldRoboto(size: CGFloat) -> UIFont {
        return Font.robotoBold.size(size)
    }
}

extension UIFont {
    static let regularRoboto = Font.robotoRegular
    
    static let headline1 = Font.boldRoboto(size: 48)
    static let headline2 = Font.boldRoboto(size: 32)
    static let headline3 = Font.boldRoboto(size: 24)
    static let headline4 = Font.regularRoboto(size: 20)
    
    static let body1Bold = Font.boldRoboto(size: 18)
    static let body1Medium = Font.regularRoboto(size: 18)
    static let newsTitle = Font.regularRoboto(size: 12)
    
    static let body2Bold = Font.boldRoboto(size: 16)
    static let body2Medium = Font.regularRoboto(size: 16)
    
    static let body3Bold = Font.boldRoboto(size: 14)
    static let body3Medium = Font.regularRoboto(size: 14)
    
}
