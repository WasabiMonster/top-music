//
//  ActivityImageView.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/31/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import UIKit

class ActivityImageView: UIImageView {
    
    var activityView: UIActivityIndicatorView?

    func showActivityIndicator() {
        DispatchQueue.main.async {
            if self.activityView == nil {
                let activityVW = UIActivityIndicatorView(style: .large)
                activityVW.color = UIColor.offWhite
                self.addSubviews([activityVW])
                self.activityView = activityVW
                NSLayoutConstraint.activate([
                    activityVW.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    activityVW.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                ])
            }
            self.activityView?.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityView?.stopAnimating()
            self.activityView?.removeFromSuperview()
            self.activityView = nil
        }
    }

}

