//
//  UILabel+Extension.swift
//  NewsApp
//
//  Created by Miran Mendelski on 13.04.2024..
//

import UIKit

extension UILabel {
    
    func style(_ font: UIFont, color: UIColor = .white, alignment: NSTextAlignment = .left) {
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
    }
}
