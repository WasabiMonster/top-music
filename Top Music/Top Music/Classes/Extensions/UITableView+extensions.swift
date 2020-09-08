//
//  UITableView+extensions.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/31/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

extension UITableView {
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let activityView = UIActivityIndicatorView(style: .large)
            activityView.backgroundColor = .almostBlack
            self.backgroundView = activityView
            activityView.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }

}
