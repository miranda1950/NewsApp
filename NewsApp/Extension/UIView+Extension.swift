//
//  UIView+Extension.swift
//  NewsApp
//
//  Created by Miran Mendelski on 09.04.2024..
//

import UIKit

extension UIView {
    
    func anchor(top: (NSLayoutYAxisAnchor, CGFloat)? = nil, bottom: (NSLayoutYAxisAnchor, CGFloat)? = nil, leading: (NSLayoutXAxisAnchor, CGFloat)? = nil, trailing: (NSLayoutXAxisAnchor, CGFloat)? = nil, size: CGSize = .zero) {
      
      translatesAutoresizingMaskIntoConstraints = false
      
      if let top = top {
        topAnchor.constraint(equalTo: top.0, constant: top.1).isActive = true
      }
      
      if let bottom = bottom {
        bottomAnchor.constraint(equalTo: bottom.0, constant: -bottom.1).isActive = true
      }
      
      if let leading = leading {
        leadingAnchor.constraint(equalTo: leading.0, constant: leading.1).isActive = true
      }
      
      if let trailing = trailing {
        trailingAnchor.constraint(equalTo: trailing.0, constant: -trailing.1).isActive = true
      }
      
      if size.height != 0 {
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
      }
      
      if size.width != 0 {
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
      }
    }
    
    func anchorToSuperview(safeArea: Bool = false, insetBy inset: CGFloat = 0) {
        guard let superview = superview else { return }
        
        if safeArea {
            anchor(top:
                    (superview.safeAreaLayoutGuide.topAnchor, inset),
                   bottom: (superview.safeAreaLayoutGuide.bottomAnchor, inset),
                   leading: (superview.safeAreaLayoutGuide.leadingAnchor, inset),
                   trailing: (superview.safeAreaLayoutGuide.trailingAnchor, inset))
        } else {
            anchor(top: (superview.topAnchor, inset),
                   bottom: (superview.bottomAnchor, inset),
                   leading: (superview.leadingAnchor, inset),
                   trailing: (superview.trailingAnchor, inset))
        }
    }
    
    func centerIn(_ view: UIView, constants: (x: CGFloat, y: CGFloat) = (x: 0, y: 0)) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constants.x).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constants.y).isActive = true
    }
}
