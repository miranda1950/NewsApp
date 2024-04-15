//
//  UISearchBar+Extension.swift
//  NewsApp
//
//  Created by Miran Mendelski on 15.04.2024..
//

import UIKit

extension UISearchBar {
    func setTextFieldColor(_ color: UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                let view = subSubView as? UITextInputTraits
                if view != nil {
                    let textField = view as? UITextField
                    textField?.backgroundColor = color
                    break
                }
            }
        }
    }
    
    func setIconColor(_ color: UIColor) {
            for subView in self.subviews {
                for subSubView in subView.subviews {
                    let view = subSubView as? UITextInputTraits
                    if view != nil {
                        let textField = view as? UITextField
                        let glassIconView = textField?.leftView as? UIImageView
                        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
                        glassIconView?.tintColor = color
                        break
                    }
                }
            }
        }
}
