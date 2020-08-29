//
//  UIViewController+extensions.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/29/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import UIKit

extension UITableViewController {
    
    func deselectSelectedRow() {
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
