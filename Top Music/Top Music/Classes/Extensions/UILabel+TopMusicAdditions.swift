//
//  UILabel+TopMusicAdditions.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  
  static func wrapping(font: UIFont, color: UIColor) -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    label.textColor = color
    label.textAlignment = .center
    return label
  }
  
  static func wrapping(font: UIFont) -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    return label
  }
  
  convenience init(font: UIFont) {
    self.init()
    self.font = font
  }
  
  convenience init(font: UIFont, color: UIColor) {
    self.init()
    self.font = font
    self.textColor = color
  }
  
  func pushNewText(_ newText: String) {
    let animation:CATransition = CATransition()
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    animation.type = CATransitionType.push
    animation.subtype = CATransitionSubtype.fromTop
    animation.duration = 0.5
    layer.add(animation, forKey: convertFromCATransitionType(CATransitionType.push))
    text = newText
  }
  
  func fadeInFromOut() {
    self.alpha = 0
    UIView.animate(withDuration: 0.35, delay: 0.3, options: .curveEaseOut, animations: {() -> Void in
      self.alpha = 1.0
    }, completion: nil)
  }
  
}

fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
    return input.rawValue
}
